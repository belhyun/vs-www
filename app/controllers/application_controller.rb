class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :get_user_id_from_acc_token
  include ApplicationHelper

  def get_user_id_from_acc_token
    @user_id = nil
    if params.has_key?("acc_token")
      @user = User.find(:first, :conditions => ["acc_token = ? AND expires >= ?",params[:acc_token], Time.now])
    elsif env.has_key?('omniauth.auth') && !env['omniauth.auth'][:uid].nil?
      @user = User.find(:first, :conditions => ["sns_id = ? AND expires >= ?",env['omniauth.auth']['uid'], Time.now])
    elsif params.has_key?("email") && params.has_key?("password")
      @user = User.find(:first, :conditions => ["email = ? AND password =  ?",params[:email], params[:password]])
    end
    @user_id = @user.id unless @user.nil?
  end

  def user_exist?
    !!@user_id
  end

  def is_auth?
    user_exist?
  end
end
