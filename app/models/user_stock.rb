class UserStock < ActiveRecord::Base
  attr_protected
  belongs_to :user
  belongs_to :stock
  belongs_to :issue
  validates_presence_of :stock_amounts , :user_id, :stock_id, :issue_id
  scope :count_by_stock, lambda {|id| where(["stock_id = ?",id]).sum(:stock_amounts)}
  scope :count_by_issue, lambda {|id| where(["issue_id = ?",id]).sum(:stock_amounts)}
  scope :get, lambda {|user_id, stock_id, issue_id| where(["user_id = ? and stock_id = ? and issue_id = ?", user_id, stock_id, issue_id])}

  def self.is_not_settled(issue_id, user_id)
    UserStock.where(["issue_id = ? AND user_id = ? AND is_settled = ?", issue_id, user_id, true]).blank?
  end

  def self.sell_stocks(user_id, stock_id, stock_amounts)
    UserStock.where(:user_id => user_id, :stock_id => stock_id).first.increment!(:stock_amounts, -stock_amounts)
  end

  def self.settle(issue_id, user_id)
    plus_money = settle_money = 0
    user_stocks = UserStock.find(:all, :conditions => ["issue_id = ? AND user_id = ?", issue_id, user_id]).each{|user_stock|
      if user_stock.stock.is_win == 1
        plus_money += (user_stock.issue.money.to_i * user_stock.stock_amounts)
        settle_money += plus_money
      else 
        settle_money -= user_stock.issue.money.to_i * user_stock.stock_amounts
      end
    }
    unless user_stocks.nil?
      UserStock.where("issue_id = ? AND user_id = ?", issue_id, user_id).update_all(:is_settled => true)
    end
    {
      :settle_money => settle_money,
      :plus_money => plus_money
    }
  end

  def self.get_stock_total_money(user_id)
    unless user_id.nil?
      UserStock.joins(:stock).select("user_stocks.*, stocks.money").where(:user_id => user_id, :is_settled => 0).sum("stocks.money*stock_amounts")
    else 
      0
    end
  end
end
