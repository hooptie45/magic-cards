require 'open-uri'
class IngestMagicSetListJob < ApplicationJob
  queue_as :default

  def perform(*args)
    set_list_url = ENV.fetch("MTG_SET_LIST_URL", "http://mtgprice.com/magic-the-gathering-prices.jsp")
    uri = URI(set_list_url)
    host = String(uri).sub(uri.path, '')
    Nokogiri::HTML(open(set_list_url).read).css("#setTable tr a @href").map(&:value).each_with_index do |path, index|
      next if index > 2
      uri.path = path
      Rails.logger.info "Queued up #{uri.to_s}"
      IngestMagicSetJob.perform_now(uri.to_s)
      # IngestMagicSetJob.set(wait: index.seconds).perform_later(uri.to_s)
    end
  end
end
