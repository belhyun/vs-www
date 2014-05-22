class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:nick, :image]
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

  def show
    user = User.find_by_id(@user_id)
    unless user.nil?
      render :json => success(user.as_json(:include => [:userStocks, :logUserStocks]))
    else
      render :json => fail(Code::MSG[:no_user_found])
    end
  end

  def image
    @user = User.find(:first, :conditions => ["id =?", @user_id])
    @user.update_attributes(profile_params.slice(:image))
    if @user.save!
      render :json => success(@user)
    else
      render :json => fail(Code::MSG[:user_image_upload_fail])
    end
  end

  def profile_params
    params.permit(:image)
  end
end
