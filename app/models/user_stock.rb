class UserStock < ActiveRecord::Base
  attr_protected
  belongs_to :user
  belongs_to :stock
  belongs_to :issue
  validates_presence_of :stock_amounts , :user_id, :stock_id, :issue_id
  scope :count_by_stock, lambda {|id| where(["stock_id = ?",id]).sum(:stock_amounts)}
  scope :count_by_issue, lambda {|id| where(["issue_id = ?",id]).sum(:stock_amounts)}
  scope :get, lambda {|user_id, stock_id, issue_id| where(["user_id = ? and stock_id = ? and issue_id = ?", user_id, stock_id, issue_id])}
end
