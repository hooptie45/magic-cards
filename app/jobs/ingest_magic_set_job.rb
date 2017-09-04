require 'open-uri'

class IngestMagicSetJob < ApplicationJob
  queue_as :default
  SET_REGEX = /scope.setList/

  def perform(set_url)
    open(set_url).each_with_index do |line, index|
      if line =~ SET_REGEX
        set = JSON.parse(line.split("=").last.strip.sub(/;$/, ''))
        KAFKA.deliver_message(JSON(set), topic: "raw_magic_set")

        set.each do |card|
          KAFKA.deliver_message(JSON(set), topic: "raw_magic_card", key: card["cardId"], partition: set_url)
          IngestMagicCardJob.perform_later(card)
        end
      end
    end
  end
end
