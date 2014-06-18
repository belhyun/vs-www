class RanksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def index 
    LogUser.log_user_id = @user_id
    @ranks = LogUser.rank(@user_id)
    @users = @ranks.paginate(:page => params[:page], :per_page => 10)
             .as_json(:include => [:user => {:include =>{:photo => {:methods => :kinds}}}])
    if is_auth?
      @success = success(@users)
      @success[:current_user] = @ranks.select{|rank| rank.is_me == 1}.first.as_json(:include => [:user => {:include =>{:photo => {:methods => :kinds}}}])
      @success[:total_cnt] = LogUser.today.count
      @success[:per_page] = 10
      @success[:page] = params[:page].to_i
      render :json => @success
    else
      render :json => fail(APP_CONFIG['unauthorized'])
    end
  end
end
