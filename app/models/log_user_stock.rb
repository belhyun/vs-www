class LogUserStock < ActiveRecord::Base
  attr_protected
  belongs_to :user
  belongs_to :stock
  belongs_to :issue
  scope :today, lambda{|stock_id| where(["DATE_FORMAT(created_at, '%Y-%m-%d') = ? AND stock_id = ?", Date.today, stock_id])}
  scope :buying, lambda{where(["stock_type = ?", Code::BUY])}
  scope :selling, lambda{where(["stock_type = ?", Code::SELL])}

  def self.insert_log(hash)
    if !hash.nil?
      LogUserStock.create!(hash)
    end
  end

  def self.total_stock_amounts(id)
    LogUserStock.where("issue_id = #{id}").count
  end
end
