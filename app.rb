# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/' do
  file = File.open('./resources/test.json')
  json = file.read
  a = JSON.parse(json)
  @titles = a['memos'].map { |memo| memo['title'] }
  erb :top
end

get '/newmemo' do
  erb :newmemo
end

get '/path/to' do
  'this is [/path/to]'
end

get '/erb_template_page' do
  erb :erb_template_page
end

not_found do
  'ファイルが存在しません'
end
