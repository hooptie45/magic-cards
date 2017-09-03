require 'open-uri'
class IngestMagicSetJob < ApplicationJob
  queue_as :default
  SET_REGEX = /scope.setList/
  def perform(set_url)
    open(set_url).each_with_index do |line, index|
      if line =~ SET_REGEX
        JSON.parse(line.split("=").last.strip.sub(/;$/, ''))
      end
    end
  end
end
