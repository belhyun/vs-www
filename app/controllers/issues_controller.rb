class IssuesController < ApplicationController
  def index
    @issues = Issue.paginate(:page => params[:page], :per_page => Issue::PER_PAGE)
    .as_json(:include => [:photos => {:methods => [:kinds], :except => [:image_content_type, :image_file_name, :image_file_size, :image_updated_at]}])
    respond_to do |format|
      if is_auth?
        @success = success(@issues)
        @success[:total_cnt] = Issue.count
        @success[:per_page] = Issue::PER_PAGE
        @success[:page] = params[:page].to_i
        format.json{render :json => @success}
      else
        format.json{render :json => fail(APP_CONFIG['unauthorized'])}
      end
    end
  end

  def open
    Issue.user_id = Stock.user_id = @user_id
    @issues = Issue.open.paginate(:page => params[:page], :per_page => Issue::PER_PAGE)
      .as_json(:methods => [:is_joining, :user_money], 
    :include => [{:stocks => {:include => {:photo => {:methods => [:kinds]}}, 
    :methods => [:user_stock_cnt, :this_week, :total, :buy_avg_money, :last_day_money]}}, 
    :photo => {:methods => [:kinds]}])
    respond_to do |format|
      if is_auth?
        @success = success(@issues)
        @success[:total_cnt] = Issue.count
        @success[:per_page] = Issue::PER_PAGE
        @success[:page] = params[:page].to_i
        format.json{render :json => @success}
      else
        format.json{render :json => fail(APP_CONFIG['unauthorized'])}
      end
    end
  end

  def show
    Issue.user_id = Stock.user_id = @user_id
    @issues = Issue.find_by_id(params[:id])
      .as_json(:methods => [:is_joining, :user_money], 
    :include => [{:stocks => {:include => {:photo => {:methods => [:kinds]}}, 
    :methods => [:user_stock_cnt, :this_week, :total, :buy_avg_money, :last_day_money]}}, 
    :photo => {:methods => [:kinds]}])
    respond_to do |format|
      if is_auth?
        @success = success(@issues)
        format.json{render :json => @success}
      else
        format.json{render :json => fail(APP_CONFIG['unauthorized'])}
      end
    end
  end

  def closed
    Issue.user_id = @user_id
    @closed_issues = Issue.closed
    @issues = @closed_issues.paginate(:page => params[:page], :per_page => Issue::PER_PAGE)
      .as_json(:methods => [:is_joining, :is_settled], 
    :include => [{:stocks => {:include => {:photo => {:methods => [:kinds]}}, 
    :methods => [:user_stock_cnt, :last_week, :this_week, :total]}}, 
    :photo => {:methods => [:kinds]}])
    @issues = @issues.to_a.reject{|o| o["is_joining"] === false || o["is_settled"] === true}
    respond_to do |format|
      if is_auth?
        @success = success(@issues)
        @success[:total_cnt] = @closed_issues.as_json(:methods => [:is_joining, :is_settled]).to_a.reject{|o| o["is_joining"] === false || o["is_settled"] === true}.count
        @success[:per_page] = Issue::PER_PAGE
        @success[:page] = params[:page].to_i
        format.json{render :json => @success}
      else
        format.json{render :json => fail(APP_CONFIG['unauthorized'])}
      end
    end
  end

  def settle
    ActiveRecord::Base.transaction do
      issue_id = settle_params[:issue_id]
      issue = Issue.find_by_id(issue_id)
      win_stock_name = issue.stocks.where("is_win = 1").first.name
      if issue.is_closed == 1
        if UserStock.is_not_settled(issue_id, @user_id)
          result = UserStock.settle(issue_id, @user_id)
          unless result.nil?
            if User.update_money(@user_id, result[:plus_money])
              json = {}
              json[:user] = User.find_by_id(@user_id)
              json[:settle_money] = result[:settle_money]
              json[:win_stock_name] = win_stock_name 
              render :json => success(json) and return
            else
              render :json => fail(Code::MSG[:transaction_fail]) and return
            end
          end
          render :json => fail(Code::MSG[:settle_fail]) and return
        else
          render :json => fail(Code::MSG[:settle_done]) and return
        end
      else
        render :json => fail(Code::MSG[:settle_ready]) and return
      end
    end
  end

  private 
  def settle_params
    params.permit(:issue_id)
  end
end
