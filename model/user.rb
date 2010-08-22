#require 'model/connection_manager'
#require 'digest/sha1'

class User < Sequel::Model
  one_to_many :points
end

