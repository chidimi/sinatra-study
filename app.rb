# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require './models/memo'

memo_accessor = MemoAccessor.new('./resources/memos.json')

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/' do
  @memos = memo_accessor.read_memos_json['memos']
  erb :top
end

get '/memos/new' do
  erb :newmemo
end

post '/memos/new' do
  memos = memo_accessor.read_memos_json['memos']
  id = if memos[-1].nil?
         1
       else
         memos[-1]['id'] + 1
       end
  new_memo = Memo.new(id, params[:title], params[:content])
  memo_accessor.add_memo(new_memo)
  redirect to('/')
end

get '/memos/:id' do
  memos = memo_accessor.read_memos_json['memos']
  @memo = memos.find { |memo| memo['id'] == params[:id].to_i }
  raise not_found if @memo.nil?

  erb :memodetail
end

delete '/memos/:id' do
  memo_accessor.delete_memo(params[:id].to_i)
  redirect to('/')
end

get '/memos/:id/edit' do
  memos = memo_accessor.read_memos_json['memos']
  @memo = memos.find { |memo| memo['id'] == params[:id].to_i }
  raise not_found if @memo.nil?

  erb :editmemo
end

patch '/memos/:id/edit' do
  edited_memo = Memo.new(params[:id].to_i, params[:title], params[:content])
  memo_accessor.edit_memo(edited_memo)
  redirect to("/memos/#{params[:id]}")
end

not_found do
  'ファイルが存在しません'
end
