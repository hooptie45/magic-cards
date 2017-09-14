require 'open-uri'

class IngestMagicSetJob < ApplicationJob

  SET_REGEX = /scope.setList/

  def perform(set_url:, perform_subtasks: :later, **kwargs)

    lines = Rails.cache.fetch(set_url, :expires_in => 1.day) do
      open(set_url).readlines
    end

    lines.each_with_index do |line, index|
      if line =~ SET_REGEX
        set = JSON.parse(line.split("=").last.strip.sub(/;$/, ''))
        set.each do |card|
          IngestMagicCardJob.send("perform_#{perform_subtasks}", raw_card: card, **kwargs)
        end
      end
    end
  end
end
