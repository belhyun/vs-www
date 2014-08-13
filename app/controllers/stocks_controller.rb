class StocksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :stock
  before_action :validate, :only => [:buy, :sell]
  def buy
    ActiveRecord::Base.transaction do
      stock_id = buy_params[:id]
      issue_id = @stock.issue.id
      stock_amounts = buy_params[:stock_amounts].to_i
      Stock.user_id = @user_id
      Issue.user_id = @user_id
      case User.buy_status(@user_id, stock_id, stock_amounts)
      when Code::MSG[:not_enough_money]
        render :json => fail(Code::MSG[:not_enough_money]) and return
      when Code::MSG[:success]
        unless UserStock.get(@user_id, stock_id, issue_id).blank?
          user_stock = UserStock.find(:first, :conditions => ["user_id = ? and stock_id = ? and issue_id = ?",@user_id, stock_id, issue_id])
          if user_stock.avg_money == 0
            avg_money = 1
          else
            avg_money = user_stock.avg_money
          end
          if !UserStock.find_by_id(user_stock.id).increment!(:stock_amounts, stock_amounts) 
            render :json => fail(Code::MSG[:buy_transaction_fail]) and return
          else
            user_stock.update_attribute(:avg_money, 
                                        ((avg_money*user_stock.stock_amounts)+(@stock.money*stock_amounts))/(user_stock.stock_amounts + stock_amounts))
          end
        else
          user_stock = UserStock.create(:user_id => @user_id, :stock_id => stock_id, :issue_id => issue_id, :stock_amounts=> stock_amounts)
          user_stock.update_attribute(:avg_money, 
                                      @stock.money*stock_amounts/stock_amounts)

        end
        if User.buy_stocks(@user_id, @stock.money, stock_amounts) && Stock.update_money(issue_id)
          insert_log(
            Code::BUY,
            stock_amounts, 
            stock_id, 
            issue_id, 
            User.user_money(@user_id),
            @stock.money,
          )
          result = success(UserStock.find_by_id(user_stock.id).as_json(:include => [:user, {:stock => {:methods => 
                                                                                                       [:user_stock_cnt, :this_week, :buy_avg_money, :total]}}]))
          result[:body][:buy_stock_amounts] = stock_amounts
          result[:body][:issue] = Issue.open.find_by_id(issue_id).as_json(:methods => [:is_joining, :user_money], 
                                                                          :include => [{:stocks => {:include => {:photo => {:methods => [:kinds]}}, 
                                                                                                    :methods => [:user_stock_cnt, :this_week, :total, :buy_avg_money, :last_day_money]}}, 
                                                                          :photo => {:methods => [:kinds]}])

          render :json => result and return
        else
          render :json => fail(Code::MSG[:buy_transaction_fail]) and return
        end
      end
    end
  end

  def insert_log(stock_type, stock_amounts, stock_id, issue_id, user_money, stock_money)
    LogUserStock.insert_log({
      :stock_type => stock_type,
      :stock_amounts => stock_amounts,
      :user_id => @user_id,
      :stock_id => stock_id,
      :issue_id => issue_id,
      :user_money => user_money,
      :stock_money => stock_money
    })
  end

  def sell
    ActiveRecord::Base.transaction do
      stock_id = buy_params[:id]
      issue_id = @stock.issue.id
      stock_amounts = buy_params[:stock_amounts].to_i
      Issue.user_id = @user_id
      Stock.user_id = @user_id
      case result = User.sell_status(@user_id, stock_id, stock_amounts)
      when Code::MSG[:success]
        user_stock = UserStock.find(:first, :conditions => ["user_id = ? and stock_id = ? and issue_id = ?",@user_id, stock_id, issue_id])
        if UserStock.sell_stocks(@user_id, stock_id, stock_amounts) && User.sell_stocks(@user_id, @stock.money, stock_amounts) && Stock.update_money(issue_id)
          if user_stock.stock_amounts == stock_amounts
            user_stock.update_attribute(:avg_money, 0)
          end
          insert_log(
            Code::SELL,
            stock_amounts, 
            stock_id, 
            issue_id, 
            User.user_money(@user_id),
            @stock.money
          )
          result = success(UserStock.find_by_id(user_stock.id).as_json(:include => [:user, {:stock => {:methods => 
                                                                                                       [:user_stock_cnt, :this_week, :buy_avg_money, :total]}}, :issue]))
          result[:body][:sell_stock_amounts] = stock_amounts
          result[:body][:issue] = Issue.open.find_by_id(issue_id).as_json(:methods => [:is_joining, :user_money], 
                                                                          :include => [{:stocks => {:include => {:photo => {:methods => [:kinds]}}, 
                                                                                                    :methods => [:user_stock_cnt, :this_week, :total, :buy_avg_money, :last_day_money]}}, 
                                                                          :photo => {:methods => [:kinds]}])

          render :json => result and return
        end
      when Code::MSG[:user_has_no_stock]
        render :json => fail(result) and return
      when Code::MSG[:user_stock_lack]
        render :json => fail(result) and return
      end
    end
  end

  def show
    @stock = Stock.find_by_id(params[:id])
    if @stock.nil?
      render :json => fail(Code::MSG[:buy_transaction_fail]) and return
    elsif @stock.money == 0
      render :json => fail(Code::MSG[:stock_money_zero]) and return
    end
    render :json => success(@stock)
  end

  private
  def buy_params
    params.permit(:id, :acc_token, :stock_amounts)
  end
  
  def sell_params
    params.permit(:id, :acc_token, :stock_amounts)
  end

  def show_params
    params.permit(:id)
  end


  def stock
    @stock = Stock.find_by_id(params[:id])
    if @stock.nil?
      render :json => fail(Code::MSG[:buy_transaction_fail]) and return
    elsif @stock.money == 0
      render :json => fail(Code::MSG[:stock_money_zero]) and return
    end
  end

  def validate
    if !params.has_key?(:stock_amounts) || params[:stock_amounts].to_i == 0
      render :json => fail(Code::MSG[:stock_amounts_is_invaild]) and return
    end
  end

  def money
    
  end
end
