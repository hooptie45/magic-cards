require 'open-uri'

# IngestMagicSetListJob.perform_now(perform_subtasks: :now)
class IngestMagicSetListJob < ApplicationJob

  def perform(perform_subtasks: :later, **kwargs)
    kwargs[:perform_subtasks] = perform_subtasks

    batch_id     = SecureRandom.base58
    set_list_url = ENV.fetch("MTG_SET_LIST_URL", "http://mtgprice.com/magic-the-gathering-prices.jsp")
    uri          = URI(set_list_url)
    host         = String(uri).sub(uri.path, '')

    html = Rails.cache.fetch(set_list_url, :expires_in => 1.day) do
      open(set_list_url).read
    end

    Nokogiri::HTML(html).css("#setTable tr a @href").map(&:value).map.with_index do |path, index|
      uri.path = path
      IngestMagicSetJob.send("perform_#{perform_subtasks}", set_url: uri.to_s, **kwargs)
      uri.to_s
    end
  end
end


