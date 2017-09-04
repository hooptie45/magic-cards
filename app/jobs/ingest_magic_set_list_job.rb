require 'open-uri'

# IngestMagicSetListJob.perform_now
class IngestMagicSetListJob < ApplicationJob
  queue_as :default

  def perform(*args)
    batch_id     = SecureRandom.base58
    set_list_url = ENV.fetch("MTG_SET_LIST_URL", "http://mtgprice.com/magic-the-gathering-prices.jsp")
    uri          = URI(set_list_url)
    host         = String(uri).sub(uri.path, '')

    Nokogiri::HTML(open(set_list_url).read).css("#setTable tr a @href").map(&:value).each_with_index do |path, index|
      uri.path = path
      Rails.logger.info "Queued up #{uri.to_s}"

      KAFKA.deliver_message(uri.to_s, topic: "raw_magic_set", partition_key: batch_id)
      IngestMagicSetJob.perform_later(uri.to_s, batch_id)
    end
  end
end


