class Stock < ActiveRecord::Base
  attr_protected
  belongs_to :issue, :counter_cache => true
  has_many :users, :through => :userStocks
  has_many :userStocks, :dependent => :destroy
  has_many :logStocks, :dependent => :destroy
  belongs_to :photo
  cattr_accessor :user_id
  accepts_nested_attributes_for :photo, :allow_destroy => true
  scope :today, lambda{ where(["created_at = ?", Date.today])}
  after_create :set_start_money

  def set_start_money
    stock = Stock.find_by_id(id)
    stock.update_attribute(:start_money, stock.money)
  end

  def self.update_money(id)
    Stock.find(:all, :conditions => ["issue_id = ?",id]).each{|stock|
      stock.update_attribute(:money, stock.issue.money * UserStock.count_by_stock(stock.id) / UserStock.count_by_issue(id).ceil.to_i)
    }
  end

  def user_stock_cnt
    user_stock = UserStock.find(:first, :conditions => ["stock_id = ? AND user_id = ?",id, Stock.user_id])
    if user_stock.nil? then 0 else user_stock.stock_amounts end
  end

  def this_week
    this_week = LogStock.where("created_at BETWEEN CURDATE()-INTERVAL 1 WEEK AND CURDATE() AND stock_id=#{id}")
      .select("stock_money, DATE_FORMAT(created_at, '%w') as day_of_week")
    day_of_week = ["0","1","2","3","4","5","6"].reject{|day| this_week.collect{|stock| stock.day_of_week}.include?(day)}
    day_of_week.each{|day|
      stock = Hash.new
      stock[:stock_money] = 0
      stock[:day_of_week] = day
      this_week.push(stock)
    }
    this_week.sort{|a,b| a[:day_of_week].to_i <=> b[:day_of_week].to_i}
  end

  def total
    UserStock.where(:issue_id => issue_id).sum(:stock_amounts)
  end

  def buy_avg_money
    LogUserStock.select("sum(stock_money*stock_amounts)/sum(stock_amounts) as avg_money").where(:stock_id => id, :user_id => Stock.user_id, :stock_type => 1).first.avg_money.to_i
  end
end
