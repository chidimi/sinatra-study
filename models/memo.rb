# frozen_string_literal: true

require 'json'

# memo file accessor
class MemoAccessor
  def initialize(filepath)
    @filepath = filepath
  end

  def add_memo(title, content)
    hash = read_memos_json
    id = numbering
    new_memo = { 'id' => id, 'title' => title, 'content' => content }
    hash['memos'].push(new_memo)
    File.open(@filepath, 'w') do |file|
      JSON.dump(hash, file)
    end
  end

  def read_memos_json
    file = File.open(@filepath)
    json = file.read
    JSON.parse(json)
  end

  def delete_memo(id)
    hash = read_memos_json
    hash['memos'] = hash['memos'].delete_if { |memo| memo['id'] == id }
    File.open(@filepath, 'w') do |file|
      JSON.dump(hash, file)
    end
  end

  def edit_memo(memo)
    delete_memo(memo.id)
    hash = read_memos_json
    edited_memo = { 'id' => memo.id, 'title' => memo.title, 'content' => memo.content }
    hash['memos'].push(edited_memo)
    hash['memos'].sort_by! { |m| m['id'] }
    File.open(@filepath, 'w') do |file|
      JSON.dump(hash, file)
    end
  end

  def numbering
    memos = read_memos_json['memos']
    if memos[-1].nil?
      1
    else
      memos[-1]['id'] + 1
    end
  end
end

# memo class
class Memo
  attr_reader :id, :title, :content

  def initialize(id, title, content)
    @id = id
    @title = title
    @content = content
  end
end
