class User < ActiveRecord::Base
  attr_protected
  before_create :gen_token, :gen_expires, :gen_identity
  #before_update :gen_token, :gen_expires, :if =>  
  has_many :stocks, :through => :userStocks
  has_many :userStocks
  has_many :logUserStocks
  scope :user_money , lambda {|user_id| find_by_id(user_id).money}
  scope :find_by_acc_token, lambda{|acc_token| find(:first, :conditions => ["acc_token = ?", acc_token])}
  belongs_to :photo
  accepts_nested_attributes_for :photo, :allow_destroy => true

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
    week_start_money = LogUser.select('user_money')
      .where("DATE(created_at) = (SELECT SUBDATE(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY)) AND user_id = #{id}")
    last_day_money = LogUser.select('user_money')
      .where("user_id = #{id}").order("created_at desc").limit(1)
    if !week_start_money.blank? && !last_day_money.blank?
      week_start_money = week_start_money.first.user_money
      last_day_money  = last_day_money.first.user_money
      result = {
        :amounts => last_day_money - week_start_money,
        :rate => sprintf("%.2f\%",((last_day_money.to_f/week_start_money) -1) *100)
      }
    else
      result = {
        :amounts => 0,
        :rate =>  '0.00%'
      }
    end
    result
  end

  def total_change
    last_day_money = LogUser.select('user_money')
      .where("user_id = #{id}").order("created_at desc").limit(1)
    if !last_day_money.blank?
      last_day_money = last_day_money.first.user_money
    else
      last_day_money = 0
    end
    {
      :amounts => last_day_money - Code::SEED_MONEY,
      :rate => sprintf("%.2f\%",((last_day_money.to_f/Code::SEED_MONEY) -1) *100)
    }
  end
end
