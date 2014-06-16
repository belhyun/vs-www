class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:is_dup, :image, :bankruptcy, :work, :gcm]
  before_action :set_user, :only => [:bankruptcy, :work]

  def index
  end
  
  def is_dup
    @user = User.find(:first, :conditions => ["email = ?",params.permit(:email)[:email]])
    if !@user.nil?
      render :json => success({code:2, msg:'exists email'})
    else
      render :json => fail('not exists')
    end
  end

  def is_valid_user
    @user = User.find(:first, :conditions => ["email = ? AND password =  ?",params[:email], params[:password]])
    if !@user.nil?
      render :json => success({code:1, msg:'valid user'})
    else
      render :json => fail('not valid')
    end

  end

  def show
    user = User.find_by_id(@user_id)
    unless user.nil?
      result = user.as_json(:methods => 
                                           [:weekly_change, :total_change], 
                                             :include =>
                                           [{:photo => 
                                             {:methods => [:medium,:large,:xlarge,:original]}},
                                           :userStocks
                                           ])

      result[:logUserStocks] = user.logUserStocks.limit(10).order("created_at desc").as_json(:include => [
                                               {:stock => {:include => [:photo => {:methods => [:medium, :original]}], 
                                                           :methods => [:user_stock_cnt, :last_week, :this_week, :total]}},
                                                :issue => {:methods => [:is_joining], :include => 
                                                          [{:photo => {:methods => [:medium,:original]}}, 
                                                :stocks => {
                                                            :include => [:photo => {:methods => [:medium, :original]}],
                                                            :methods => [:user_stock_cnt, :last_week, :this_week, :total]}, 
                                                :photo => {:methods => [:medium,:large,:xlarge,:original]}]}])
      render :json => success(result)
    else
      render :json => fail(Code::MSG[:no_user_found])
    end
  end

  def image
    @user = User.find(:first, :conditions => ["id =?", @user_id])
    unless @user.photo.nil?
      @user.photo.update_attributes(:image => profile_params[:photo])
    else
      @user.photo = Photo.create!(:image => profile_params[:photo])
    end

    if @user.save!
      render :json => success(@user.as_json(:include => [:photo => {:methods => [:medium,:large,:xlarge,:original]}]))
    else
      render :json => fail(Code::MSG[:user_image_upload_fail])
    end
  end

  def bankruptcy
    if @user.money < Code::BANKRUPTCY_STD_MONEY &&  UserStock.count(:conditions => ["user_id = ?", @user_id]) == 0 && (Time.now - @user.last_bankruptcy)/86400.to_f > 7.0
      if @user.update_attributes(:last_bankruptcy => Time.now) && @user.increment!(:money, Code::BANKRUPTCY_STD_MONEY)
        redirect_to user_url(@user, :acc_token => params[:acc_token]) 
      else
        render :json =>fail(Code::MSG[:transaction_fail])
      end
    else
      render :json =>fail(Code::MSG[:not_bankruptcy])
    end
  end

  def work
    work = Work.find_by_id(work_params[:work_id])
    if @user.last_work.nil? || (Time.now - @user.last_work)/86400.to_f > 1.0
      if @user.update_attributes(:last_work => Time.now) && User.update_money(@user_id, work.give_money)
        redirect_to user_url(@user, :acc_token => params[:acc_token]) 
      else
        render :json =>fail(Code::MSG[:transaction_fail])
      end
    else
      render :json =>fail(Code::MSG[:not_work])
    end
  end

  def profile_params
    params.permit(:photo)
  end

  def work_params
    params.permit(:work_id)
  end

  private 
  def set_user
    @user = User.find_by_id(@user_id)
  end
end
