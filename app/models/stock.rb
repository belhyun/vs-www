class Stock < ActiveRecord::Base
  attr_protected
  belongs_to :issue, :counter_cache => true
  has_many :users, :through => :userStocks
  has_many :userStocks
  cattr_accessor :user_id

  def self.update_money(id)
    stock = Stock.find_by_id(id)
    stock.update_attribute(:money, (stock.money * UserStock.count_by_stock(id) / UserStock.count_by_issue(stock.issue.id)).ceil.to_i)
    stock.money
  end

  def user_stock_cnt
    user_stock = UserStock.find(:first, :conditions => ["stock_id = ? AND user_id = ?",id, Stock.user_id])
    if user_stock.nil? then 0 else user_stock.stock_amounts end
  end

end
