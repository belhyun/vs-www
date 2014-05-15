class StocksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def buy
    #모든 조건 통과했을 때 생성
    @user_stock = UserStock.new(:user_id => @userId, :stock_id => buy_params[:id], :issue_id => Stock.find_by_id(buy_params[:id]).issue.id,
                                :buy_cnt => buy_params[:buy_cnt])
    if @user_stock.save! && Stock.update_money(buy_params[:id])
      render :json => success(UserStock.find_by_id(@user_stock.id).as_json(:include => [:user, :stock, :issue]))
    else
    end
  end

  def sell
  end

  private
  def buy_params
    params.permit(:id, :acc_token, :buy_cnt)
  end

end
