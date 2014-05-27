class User < ActiveRecord::Base
  attr_protected
  before_create :gen_token, :gen_expires, :gen_identity
  #before_update :gen_token, :gen_expires, :if =>  
  has_many :stocks, :through => :userStocks
  has_many :userStocks
  has_many :logUserStocks
  attr_accessor :image, :image_url
  has_attached_file :image, :styles => { :xlarge => "180x180#", :large => "130x130#", :medium => "768x200#", :small => "45x45#" },
    :url => "/images/photos/:id/:id_:style.:extension"
  before_validation :download_remote_image, :if => :image_url_provided?
  scope :user_money , lambda {|user_id| find_by_id(user_id).money}

  def image_url_provided?
    !self.image_url.blank? 
  end

  def download_remote_image
    self.image = do_download_remote_image
    #self.image_remote_url = image_url
  end

  def do_download_remote_image
    io = open(URI.parse(image_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end

  def gen_token
    self.acc_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(acc_token: random_token)
    end
  end
  def gen_expires
    self.expires = Time.now + 60.days
  end
  def gen_identity
    case mem_type
    when 'G'
      self.name = "VS_#{User.maximum('id').to_i + 1}"
      #self.email = "GUEST_#{User.maximum('id').to_i + 1}@versus.com"
    end
  end
  def expires=(expires)
    write_attribute(:expires, expires)
  end
  def expires
    read_attribute(:expires)
  end

  def self.buy_status(user_id, stock_id, stock_amounts)
    user = User.find_by_id(user_id)
    stock = Stock.find_by_id(stock_id)
    if(user.money < stock.money * stock_amounts || user.money == 0)
      result = Code::MSG[:not_enough_money]
    elsif(stock.money <= 0)
      result = Code::MSG[:stock_money_zero]
    else
      result = Code::MSG[:success]
    end
    result
  end

  def self.sell_status(user_id, stock_id, stock_amounts)
    user_stock_amounts = UserStock.select(:stock_amounts).where(:user_id => user_id, :stock_id => stock_id)
    if user_stock_amounts.blank?
      result = Code::MSG[:user_has_no_stock]
    elsif user_stock_amounts.first.stock_amounts < stock_amounts
      result = Code::MSG[:user_stock_lack]
    else
      result = Code::MSG[:success]
    end
    result
  end

  def self.update_money(user_id, money)
    User.find_by_id(user_id).increment!(:money, money)
  end

  def self.buy_stocks(user_id, stock_money, stock_amounts)
    User.update_money(user_id, -stock_money * stock_amounts)
  end

  def self.sell_stocks(user_id, stock_money, stock_amounts)
    User.update_money(user_id, stock_money*stock_amounts*(1-Code::COMMISION))
  end

  def weekly_change
    user = User.find_by_id(id)
    last_week_money = LogUser.select("user_money").where("created_at BETWEEN CURDATE() - INTERVAL 1 WEEK - (DATE_FORMAT(CURDATE(), '%w')+1) AND CURDATE() - (DATE_FORMAT(CURDATE(), '%w') -1) AND user_id =#{id}")
    {
      :weekly_money => 0,
      :weekly_change => 0
    }
  end

  def total_change
    user_money = User.find_by_id(id).money
    {
      :amounts => user_money - Code::SEED_MONEY,
      :rate => sprintf("%.2f\%",((user_money.to_f/Code::SEED_MONEY) -1) *100)
    }
  end
end
