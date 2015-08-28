source 'https://www.rubygems.org'
ruby '2.2.2'

gem 'sinatra'
gem 'endpoint_base', github: 'spree/endpoint_base'
gem 'tilt', '~> 1.4'
gem 'tilt-jbuilder', require: 'sinatra/jbuilder'
gem 'savon', '~> 2.0'

group :development do
  gem 'pry'
end

group :test do
  gem 'rspec', '~> 3.0'
  gem 'rack-test'
  gem 'webmock'
end

group :production do
  gem 'foreman'
  gem 'puma'
end
