class Photo < ActiveRecord::Base
  belongs_to :issue
  attr_protected
  attr_accessor :image
  has_attached_file :image, :styles => { :xlarge => "180x180#", :large => "130x130#", :medium => "104x104#", :small => "45x45#" },
    :url => "/images/photos/:id/:id_:style.:extension"
  def medium 
    sprintf("%s",image.url(:medium))
  end
end
