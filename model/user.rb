require 'digest/sha1'
require 'lib/tropo.rb'

class String
  def self.random_chars( length )
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    return (0...length).map{ chars[Kernel.rand(chars.length)] }.join
  end
end

class User < Sequel::Model
  one_to_many :alerts

  def before_create
    self.password (String.random_char 10)
    Tropo.send_text(self.phone_number,'Reply with \"VERIFY\" to complete signup.  Your password is: '+self.password)
    self.salt = Time.now.to_f.to_s
  end

  def before_save
    self.email = self.email.to_s.downcase
  end

  def authenticate?(plaintext)
    return ((User.hash_password plaintext, self.salt) == self.password)
  end

  def reset_password!
    new_password = (String.random_chars 10)
    self.password = new_password
    return new_password
  end

  def password=(plaintext)
    self.password = (User.hash_password plaintext, self.salt)
  end

  def authenticate?(plaintext)
    return ((User.hash_password plaintext, self.salt) == password)
  end

private
  def self.hash_password(plaintext, salt)
    return (Digest::SHA1.hexdigest "--[#{plaintext}]==[#{salt}]--")
  end

end

