require 'bundler'
require 'bundler/setup'
require 'active_support/inflector'
require 'sinatra'

Bundler.require :default, (ENV['RACK_ENV'] || :development).to_sym

require './lib/urlify.rb'

set :bind, '0.0.0.0'
set :public_folder, 'public'

before do
 content_type 'application/json'
end

get '/urlify' do
  URLify.find(params[:string])
end
