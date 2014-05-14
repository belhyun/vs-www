class Issue < ActiveRecord::Base
  PER_PAGE = 2
  attr_protected
  has_many :photos
  accepts_nested_attributes_for :photos, :allow_destroy => true
  
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
