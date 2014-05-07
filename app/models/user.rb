class User < ActiveRecord::Base
  attr_protected
  before_create :gen_token, :gen_expires, :gen_identity
  #attr_accessor :expires
  def gen_token
    self.acc_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(acc_token: random_token)
    end
  end
  def gen_expires
    self.expires = Time.now + 60.days
  end
  def gen_identity
    case mem_type
    when 'G'
      self.name = self.nickname = "GUEST_#{User.maximum('id').to_i + 1}"
      self.email = "GUEST_#{User.maximum('id').to_i + 1}@versus.com"
    end
  end
  def expires=(expires)
    write_attribute(:expires, expires)
  end
  def expires
    read_attribute(:expires).strftime("%Y%m%d%H%M%S")
  end
end
