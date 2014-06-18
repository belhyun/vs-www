class LogUser < ActiveRecord::Base
  attr_protected
  belongs_to :user
  scope :today, lambda{where(["DATE_FORMAT(created_at, '%Y-%m-%d') = ?", Date.today])}
  scope :rank , lambda{|user_id| select("users.name, log_users.user_id = #{user_id} as is_me, log_users.*, @rownum := @rownum + 1 as rank")
    .from("(select @rownum := 0) b, log_users")
    .joins(:user).today.order("user_money desc")}
  cattr_accessor :log_user_id

  def self.log_user_info
    User.all.each{|user|
      begin
        user = User.find_by_id(user.id)
        stock_total_money = UserStock.get_stock_total_money(user.id)
        unless user.nil? 
          LogUser.create!(:user_id => user.id, :user_money => user.money + stock_total_money)
        end
      rescue
      end
    }
  end
end
