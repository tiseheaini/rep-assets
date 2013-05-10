# encoding: utf-8
class User < ActiveRecord::Base

  attr_accessible :u_name, :p_salt, :p_hash, :password, :password_confirmation
  validates :u_name, :presence => {:message => "用户名不能为空"}
  validates :u_name, :uniqueness => {:message => "用户名已经有人注册过了"}
  validates :password, :confirmation => {:message => "两次输入的密码不一样"}
  def password
    @password
  end
  
  def password=(pass)
    return unless pass
    @password = pass
    generate_password(pass)
  end
  

  # 此处用动词形式(authenticate)更加合适, 特此说明一下. 感谢 Chen Kai 同学的提醒.
  def self.authentication(login, password)
    user = User.find_by_u_name(login)
    if user && Digest::SHA256.hexdigest(password + user.p_salt) == user.p_hash
      return user
    end
    false
  end
  
  private
  def generate_password(pass)
    salt = Array.new(10){rand(1024).to_s(36)}.join
    self.p_salt, self.p_hash = 
      salt, Digest::SHA256.hexdigest(pass + salt)
  end
end
