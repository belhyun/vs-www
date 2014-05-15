class Stock < ActiveRecord::Base
  attr_protected
  belongs_to :issue, :counter_cache => true
  has_many :users, :through => :userStocks
  has_many :userStocks

  def self.update_money(id)
    stock = Stock.find_by_id(id)
    stock.update_attribute(:money, stock.money * UserStock.count_by_stock(id) / UserStock.count_by_issue(stock.issue.id))
  end
end
