class Issue < ActiveRecord::Base
  PER_PAGE = 10
  attr_protected
  has_many :photos
  has_many :stocks, :dependent => :destroy
  has_many :userStocks
  has_many :logUserStocks
  accepts_nested_attributes_for :photos, :allow_destroy => true
  accepts_nested_attributes_for :stocks, :allow_destroy => true
  scope :open , lambda {where("end_date >= CURDATE()")} 
  scope :closed , lambda {where("end_date < CURDATE()")}
  
  def total_cnt
    Issue.count
  end

  def per_page
    PER_PAGE
  end

  def as_json(options = {})
    h = super(options)
  end
=begin
  def last_week_stock_amounts
    LogUserStock.where("created_at BETWEEN (CURDATE()-INTERVAL 1 WEEK - DAYOFWEEK(CURDATE())) AND (CURDATE() - DAYOFWEEK(CURDATE())) AND issue_id=#{id}").sum(:stock_amounts)
  end

  def this_week_stock_amounts
    week_stocks = LogUserStock.where("created_at BETWEEN CURDATE()-INTERVAL 1 WEEK AND CURDATE() + INTERVAL 1 DAY AND issue_id=#{id}").group("DAY(created_at)")
      .select("SUM(stock_amounts) as stock_amounts, DATE_FORMAT(created_at, '%w') as day_of_week")
    day_of_week = ["0","1","2","3","4","5","6"].reject{|day| week_stocks.collect{|stock| stock.day_of_week}.include?(day)}
    day_of_week.each{|day|
      stock = Hash.new
      stock[:stock_amounts] = 0
      stock[:day_of_week] = day
      week_stocks.push(stock)
    }
    week_stocks.sort{|a,b| a[:day_of_week].to_i <=> b[:day_of_week].to_i}
  end 

  def total_stock_amounts
    LogUserStock.where("issue_id = #{id}").count
  end
=end
end
