# frozen_string_literal: true

require 'pg'
require 'yaml'

# memo file accessor
class MemoAccessor
  def initialize
    @connect = PG.connect(YAML.load_file('./database.yml')['db'])
    @connect.exec("CREATE TABLE IF NOT EXISTS memos (
    id serial primary key,
    title varchar(30),
    content varchar(200));")
  end

  def add_memo(title, content)
    @connect.exec('INSERT INTO memos (title, content) VALUES ($1, $2)', [title, content])
  end

  def read_memos
    @connect.exec('SELECT * FROM memos order by id')
  end

  def read_memo_by_id(id)
    @connect.exec('SELECT * FROM memos WHERE id = $1', [id])
  end

  def delete_memo(id)
    @connect.exec('DELETE FROM memos WHERE id = $1', [id])
  end

  def edit_memo(memo)
    @connect.exec('UPDATE memos SET title = $1, content = $2 where id = $3', [memo.title, memo.content, memo.id])
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
