source 'https://www.rubygems.org'
ruby '2.2.2'

gem 'sinatra'
gem 'endpoint_base', github: 'spree/endpoint_base'
gem 'tilt', '~> 1.4'
gem 'tilt-jbuilder', require: 'sinatra/jbuilder'
gem 'savon', '~> 2.0'

group :development, :test do
  gem 'rspec', '~> 3.0'
  gem 'guard-rspec', require: false
  gem 'rack-test'
  gem 'webmock'
  gem 'pry'
end

group :production do
  gem 'foreman'
  gem 'puma'
end
