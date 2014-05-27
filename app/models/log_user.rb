class LogUser < ActiveRecord::Base
  attr_protected
  belongs_to :user
  def self.log_user_info
    User.all.each{|user|
      begin
        user = User.find_by_id(user.id)
        unless user.nil? 
          LogUser.create!(:user_id => user.id, :user_money => user.money)
        end
      rescue
      end
    }
  end
end
