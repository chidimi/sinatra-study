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
  redirect to('/memos')
end

get '/memos' do
  @title = 'メモ一覧'
  @memos = memo_accessor.read_memos_json['memos']
  erb :memos
end

get '/memos/new' do
  @title = 'メモ新規作成'
  erb :newmemo
end

post '/memos' do
  memo_accessor.add_memo(param[:title], param[:content])
  redirect to('/')
end

get '/memos/:id' do
  @title = 'メモ詳細'
  memos = memo_accessor.read_memos_json['memos']
  @memo = memos.find { |memo| memo['id'] == params[:id].to_i }
  halt 400 if @memo.nil?

  erb :memodetail
end

delete '/memos/:id' do
  memo_accessor.delete_memo(params[:id].to_i)
  redirect to('/')
end

get '/memos/:id/edit' do
  @title = 'メモ編集'
  memos = memo_accessor.read_memos_json['memos']
  @memo = memos.find { |memo| memo['id'] == params[:id].to_i }
  halt 400 if @memo.nil?

  erb :editmemo
end

patch '/memos/:id' do
  memos = memo_accessor.read_memos_json['memos']
  target_memo = memos.find { |memo| memo['id'] == params[:id].to_i }
  halt 400 if target_memo.nil?

  edited_memo = Memo.new(params[:id].to_i, params[:title], params[:content])
  memo_accessor.edit_memo(edited_memo)
  redirect to("/memos/#{params[:id]}")
end

not_found do
  'ファイルが存在しません'
end

error 400 do
  'client error'
end
