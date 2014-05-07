class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:nick]
  def index
  end
  
  def nick
    @user = User.find(:first, :conditions => ["nickname = ?",params.permit(:nick)[:nick]])
    if !@user.nil?
      render :json => success('exists nick')
    else
      render :json => fail('not exists nick')
    end
  end
end
