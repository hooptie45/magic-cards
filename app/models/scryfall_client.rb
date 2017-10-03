class ScryfallClient
  include Enumerable

  cattr_accessor :store
  self.store = ActiveSupport::Cache::FileStore.new "tmp/scryfall-client-cache",
                                                   :namespace => Date.today.to_s,
                                                   :expires_in => 1.day

  attr_accessor :client

  def initialize
    @client = Faraday.new(:url => "https://api.scryfall.com") do |builder|
      builder.use :http_cache, store: store
      builder.use FaradayMiddleware::FollowRedirects, limit: 5
      builder.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
      builder.use FaradayMiddleware::Mashify
      builder.use FaradayMiddleware::Instrumentation
      builder.response :caching do
        store
      end

      builder.adapter Faraday.default_adapter
    end
    @client
  end

  def fetch(url)
    client.get(url) do |req|
      yield(req) if block_given?
    end
  end

  def find_by_name(name)
    resp = fetch("/cards/named") do |req|
      req.params[:fuzzy] = name
    end
    normalize(resp.body)
  end

  def normalize(raw_card)
    Hashie::Mash.new(raw_card) if raw_card['code'] != 'not_found'
  end

  def each(path = nil, &block)
    resp = client.get(path || "/cards") do |req|
      req.params[:format] = "json"
    end

    each(resp.body['next_page'], &block) if resp.body['has_more']
    resp.body['data'].each do |raw_card|
      if card = normalize(raw_card)
        yield(card, path, resp.body)
      end
    end
  end
end
