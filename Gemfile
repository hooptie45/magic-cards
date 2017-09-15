source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Looking to use the Edge version? gem 'rails', github: 'rails/rails'
gem 'rails'

# Use Puma as the app server
gem 'puma', '~> 3.10'

# Use Rack Timeout. Read more: https://github.com/heroku/rack-timeout
gem 'rack-timeout', '~> 0.4'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use PostgreSQL as the database for Active Record
gem 'pg', '~> 0.21'
gem 'faraday'
# Use Redis Rails to set up a Redis backed Cache and / or Session
gem 'redis-rails', '~> 5.0'

# Use Sidekiq as a background job processor through Active Job
gem 'sidekiq', '~> 5.0'
gem 'hashie'
gem 'sass-rails', '~> 5.0'

# Use Uglifier as the compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jQuery as the JavaScript library
gem 'jquery-rails', '~> 4.3'
gem 'nokogiri'
# Use Turbolinks. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Use Bootstrap SASS for Bootstrap support
gem 'bootstrap-sass', '~> 3.3'
# Use Font Awesome Rails for Font Awesome icons
gem 'font-awesome-rails', '~> 4.7'
gem 'haml'

gem 'graphiql-rails'
gem 'ruby-kafka'
gem 'graphql'
gem 'graphql-batch'
gem 'bulk_insert'
gem 'seed_dump'
gem 'sidekiq-unique-jobs'
gem 'acts-as-taggable-on'

group :test do
  gem 'guard'
  gem 'guard-rspec'
  gem 'rspec'
  gem 'rspec-given'
end

group :development, :test do
  # Call 'byebug' anywhere in your code to drop into a debugger console
  gem 'rspec'
  gem 'rspec-its'
  gem 'rspec-rails'
  gem 'byebug', platform: :mri
  gem 'pry'
  gem 'pry-rails'
  # gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %>
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Use Spring. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'

