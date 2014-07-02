class SessionsController < ApplicationController
  GUEST = 'G'
  TWITTER = 'T'
  FACEBOOK = 'F'
  
  def create
    info = env['omniauth.auth']
    if !info.nil? 
      case info[:provider]
      when 'twitter'
        #if !info[:info][:nickname].nil? && !User.fnid_by_nickname(info[:info][:nickname]).blank?
        #end
        gon.user = User.create_with(:name => info[:info][:name], :image => info[:info][:image], :sns_id => info[:uid],
                                    :email => "#{info[:info][:name]}@twitter.com", :mem_type => TWITTER,
                                    :money => Code::SEED_MONEY)
          .find_or_create_by(:email => "#{info[:info][:name]}@twitter.com")
      when 'facebook'
          gon.user = User.create_with(:name => info[:info][:name], :image_url => info[:info][:image], :sns_id => info[:uid],
                           :email => info[:info][:email], :mem_type => FACEBOOK,
                           :money => Code::SEED_MONEY)
                  .find_or_create_by(:email => info[:info][:email])
      end
    end
    render :vs, :layout => false
  end

  def vs
    if User.find_by_email(params.permit(:email)[:email]).blank?
      gon.user = User.create(:mem_type => GUEST, :money => Code::SEED_MONEY,
                             :nickname => params.permit(:nick)[:nick],
                             :email => params.permit(:email)[:email],
                             :password => params.permit(:password)[:password])
    else
      gon.user = User.update(@user_id,:acc_token => User.new.gen_token, :expires => User.new.gen_expires) 
    end
    respond_to do |format|
      format.html {render layout: false}
      format.js {render layout: false}
    end
  end

  def signin
    user = User.find(:first, :conditions => ["email = ? AND password =  ?",params[:email], params[:password]])
    gon.user = User.update(user.id,:acc_token => User.new.gen_token, :expires => User.new.gen_expires) 
    render :vs, :layout => false
  end

  def logout
    user = User.find_by_id(@user_id)
    unless user.nil?
      if user.update_attributes(:expires => DateTime::now - 999.days)
        render :json => success(nil)
      else
        render :json => fail(Code::MSG[:transaction_fail])
      end
    else
      render :json => fail(Code::MSG[:user_not_found])
    end
  end

  private
  def process_uri(uri)
    require 'open-uri'
    require 'open_uri_redirections'
    open(uri, :allow_redirections => :safe) do |r|
      r.base_uri.to_s
    end
  end
end
