class Issue < ActiveRecord::Base
  PER_PAGE = 10
  attr_protected
  has_many :photos
  has_many :stocks, :dependent => :destroy
  has_many :userStocks
  accepts_nested_attributes_for :photos, :allow_destroy => true
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

end
