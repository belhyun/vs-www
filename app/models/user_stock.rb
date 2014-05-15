class UserStock < ActiveRecord::Base
  attr_protected
  belongs_to :user
  belongs_to :stock
  belongs_to :issue
  scope :count_by_stock, lambda {|id| UserStock.count(:conditions => ["stock_id = ?",id])}
  scope :count_by_issue, lambda {|id| UserStock.count(:conditions => ["issue_id = ?",id])}
end
