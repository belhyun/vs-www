class LogStock < ActiveRecord::Base
  attr_protected
  def self.log_stock_info
    Stock.joins(:issue).where(["end_date >= CURDATE() AND is_closed = 0"]).each{|stock|
      log_user_stock = LogUserStock.where("created_at = CURDATE()").group(:stock_id)
      stock_buying  = LogUserStock.today(stock.id).buying.count
      stock_selling = LogUserStock.today(stock.id).selling.count
      LogStock.create!(:stock_id => stock.id, :stock_buying => stock_buying, :stock_selling => stock_selling, :stock_money => stock.money)
    }
  end
end
