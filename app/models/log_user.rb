class LogUser < ActiveRecord::Base
  attr_protected
  belongs_to :user
  scope :today, lambda{where(["DATE_FORMAT(created_at, '%Y-%m-%d') = ?", Date.today])}
  scope :rank , lambda{|user_id| select("t.name, t.user_id = #{user_id} as is_me, 
t.*, @rownum := @rownum + 1 as rank").
  from("( 
        select log_users.*, users.name, users.nickname from log_users 
        INNER JOIN `users` ON `users`.`id` = `log_users`.`user_id` WHERE 
        (DATE_FORMAT(created_at, '%Y-%m-%d') = CURDATE()) order by user_money desc limit 99
      ) t,
      (select @rownum := 0) b")
   }
  cattr_accessor :log_user_id

  def self.log_user_info
    User.all.each{|user|
      begin
        user = User.find_by_id(user.id)
        stock_total_money = UserStock.get_stock_total_money(user.id)
        if !user.nil?  && (user.is_admin.nil? || user.is_admin == 0)
          LogUser.create!(:user_id => user.id, :user_money => user.money + stock_total_money)
        end
      rescue
      end
    }
  end
end
