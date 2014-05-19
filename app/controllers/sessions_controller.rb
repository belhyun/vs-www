class SessionsController < ApplicationController
  GUEST = 'G'
  TWITTER = 'T'
  FACEBOOK = 'F'
  
  def create
    info = env['omniauth.auth']
    if !info.nil? 
      case info[:provider]
      when 'twitter'
        if !user_exist?
          gon.user = User.create_with(:name => info[:info][:name], :image => info[:info][:image], :sns_id => info[:uid],
                           :email => "#{info[:info][:name]}@twitter.com", :mem_type => TWITTER,
                           :money => APP_CONFIG['seed_money'], :nickname => info[:info][:nickname])
                  .find_or_create_by(:email => "#{info[:info][:name]}@twitter.com")
        else
          gon.user = User.update(@user_id,:acc_token => User.new.gen_token, :expires => User.new.gen_expires) 
        end
      when 'facebook'
        if !user_exist?
          gon.user = User.create_with(:name => info[:info][:name], :image => info[:info][:image], :sns_id => info[:uid],
                           :email => info[:info][:email], :mem_type => FACEBOOK,
                           :money => APP_CONFIG['seed_money'], :nickname => info[:info][:name])
                  .find_or_create_by(:email => info[:info][:email])
        else
          gon.user = User.update(@user_id,:acc_token => User.new.gen_token, :expires => User.new.gen_expires) 
        end
      end
    end
    render :guest, :layout => false
  end

  def guest
    if !user_exist?
      gon.user = User.create(:mem_type => GUEST, :money => APP_CONFIG['seed_money'],:nickname => params.permit(:nick)[:nick])
    else
      gon.user = User.update(@user_id,:acc_token => User.new.gen_token, :expires => User.new.gen_expires) 
    end
    respond_to do |format|
      format.html {render layout: false}
      format.js {render layout: false}
    end
  end
end
