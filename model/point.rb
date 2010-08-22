#require 'model/connection_manager'
#require 'digest/sha1'

class Point < Sequel::Model
  many_to_one :user
end

