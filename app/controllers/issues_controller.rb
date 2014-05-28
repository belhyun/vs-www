class IssuesController < ApplicationController
  def index
    @issues = Issue.paginate(:page => params[:page], :per_page => Issue::PER_PAGE)
    .as_json(:include => [:photos => {:methods => [:medium], :except => [:image_content_type, :image_file_name, :image_file_size, :image_updated_at]}])
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
      .as_json(:methods => [:is_joining], 
    :include => [{:stocks => {:include => {:photo => {:methods => [:medium,:large,:xlarge,:original]}}, 
    :methods => [:user_stock_cnt, :last_week, :this_week, :total]}}, 
    :photo => {:methods => [:medium,:large,:xlarge,:original]}])
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

  def closed
    @issues = Issue.closed.paginate(:page => params[:page], :per_page => Issue::PER_PAGE)
      .as_json(:methods => [:is_joining], 
    :include => [{:stocks => {:include => {:photo => {:methods => [:medium,:large,:xlarge,:original]}}, 
    :methods => [:user_stock_cnt, :last_week, :this_week, :total]}}, 
    :photo => {:methods => [:medium,:large,:xlarge,:original]}])

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

  def settle
    issue_id = settle_params[:issue_id]
    issue = Issue.find_by_id(issue_id)
    if UserStock.is_not_settled(issue_id, @user_id)
      result = UserStock.settle(issue_id, @user_id)
      unless result.nil?
        if User.update_money(@user_id, result[:plus_money])
          json = {}
          json[:user] = User.find_by_id(@user_id)
          json[:settle_money] = result[:settle_money]
          render :json => success(json) and return
        else
          render :json => fail(Code::MSG[:transaction_fail]) and return
        end
      end
      render :json => fail(Code::MSG[:settle_fail]) and return
    else
      render :json => fail(Code::MSG[:settle_done]) and return
    end
  end

  private 
  def settle_params
    params.permit(:issue_id)
  end
end
