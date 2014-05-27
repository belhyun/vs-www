class LogStock < ActiveRecord::Base
  attr_protected
  def self.log_stock_info
    LogUserStock.where(["created_at >= ? AND created_at < ?",Date.today, Date.today+1]).each{|log_user_stock|
      begin
        stock = log_user_stock.stock
        unless stock.nil?
          stock_buying  = LogUserStock.today(stock.id).buying.count
          stock_selling = LogUserStock.today(stock.id).selling.count
          stock_money = stock.money
          LogStock.create!(:stock_id => stock.id, :stock_buying => stock_buying, :stock_selling => stock_selling, :stock_money => stock_money)
        else
          next
        end
      rescue
      end
    }
  end
end
