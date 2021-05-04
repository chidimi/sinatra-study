# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

MEMO_FILE_PATH = './resources/memos.json'

def read_memos_json
  file = File.open(MEMO_FILE_PATH)
  json = file.read
  JSON.parse(json)
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/' do
  @memos = read_memos_json['memos']
  p @memos
  erb :top
end

get '/newmemo' do
  erb :newmemo
end

post '/newmemo' do
  memos = read_memos_json['memos']
  memos.each do |memo|
    memo[]
  title = params[:title]
  content = params[:content]
end

get '/memodetail/:id' do
  memos = read_memos_json['memos']
  @memo = memos.find { |memo| memo['id'] == params[:id] }

  erb :memodetail
end

delete '/memodetail/:id' do
  hash = read_memos_json
  hash['memos'] = hash['memos'].delete_if { |memo| memo['id'] == params[:id] }
  File.open(MEMO_FILE_PATH, 'w') do |file|
    JSON.dump(hash, file)
  end
  redirect to('/')
end

get '/editmemo/:id' do
  memos = read_memos_json['memos']
  @memo = memos.find { |memo| memo['id'] == params[:id] }

  erb :editmemo
end

get '/erb_template_page' do
  erb :erb_template_page
end

not_found do
  'ファイルが存在しません'
end
