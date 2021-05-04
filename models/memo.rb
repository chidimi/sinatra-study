# frozen_string_literal: true

require 'json'

# memo file accessor
class Memo
  def initialize(filepath)
    @filepath = filepath
  end

  def read_memos_json
    file = File.open(@filepath)
    json = file.read
    JSON.parse(json)
  end
end
