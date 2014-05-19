class StocksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :stock
  def buy
    stock_id = buy_params[:id]
    issue_id = stock.issue.id
    stock_amounts = buy_params[:stock_amounts].to_i
    case User.buy_status(@user_id, stock_id, stock_amounts)
    when Code::MSG[:not_enough_money]
      render :json => fail(Code::MSG[:not_enough_money]) and return
    when Code::MSG[:success]
      unless UserStock.get(@user_id, stock_id, issue_id).blank?
        user_stock = UserStock.find(:first, :conditions => ["user_id = ? and stock_id = ? and issue_id = ?",@user_id, stock_id, issue_id])
        if !UserStock.find_by_id(user_stock.id).increment!(:stock_amounts, stock_amounts) 
          render :json => fail(Code::MSG[:buy_transaction_fail]) and return
        end
      else
        user_stock = UserStock.create(:user_id => @user_id, :stock_id => stock_id, :issue_id => issue_id, :stock_amounts=> stock_amounts)
      end
      if User.buy_stocks(@user_id, @stock.money, stock_amounts) && money = Stock.update_money(stock_id)
        result = success(UserStock.find_by_id(user_stock.id).as_json(:include => [:user, :stock, :issue]))
        result[:body][:buy_stock_amounts] = stock_amounts
        result[:body][:stock_money] = money
        render :json => result and return
      else
        render :json => fail(Code::MSG[:buy_transaction_fail]) and return
      end
    end
  end

  def sell
  end

  private
  def buy_params
    params.permit(:id, :acc_token, :stock_amounts)
  end

  def stock
    @stock = Stock.find_by_id(params[:id])
  end
end
