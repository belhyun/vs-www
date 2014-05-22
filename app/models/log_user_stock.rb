class LogUserStock < ActiveRecord::Base
  attr_protected
  belongs_to :user
  belongs_to :stock
  belongs_to :issue

  def self.insert_log(hash)
    if !hash.nil?
      LogUserStock.create!(hash)
    end
  end

  def self.total_stock_amounts(id)
    LogUserStock.where("issue_id = #{id}").count
  end
end
