class SessionsController < ApplicationController
  GUEST = 'G'
  TWITTER = 'T'
  FACEBOOK = 'F'
  
  def create
    info = env['omniauth.auth']
    if !info.nil?
      case info[:provider]
      when 'twitter'
        gon.user = User.create_with(:name => info[:info][:name], :image => info[:info][:image], :sns_id => info[:uid],
                         :email => "#{info[:info][:name]}@twitter.com", :mem_type => TWITTER,
                         :money => APP_CONFIG['seed_money'], :nickname => info[:info][:nickname])
                .find_or_create_by(:email => "#{info[:info][:name]}@twitter.com")
      when 'facebook'
       gon.user = User.create_with(:name => info[:info][:name], :image => info[:info][:image], :sns_id => info[:uid],
                         :email => info[:info][:email], :mem_type => FACEBOOK,
                         :money => APP_CONFIG['seed_money'], :nickname => info[:info][:name])
                .find_or_create_by(:email => info[:info][:email])
      end
    end
    render :guest, :layout => false
  end

  def guest
    gon.user = User.create(:mem_type => GUEST, :money => APP_CONFIG['seed_money'])
    gon.user = User.find_by_id(100)
    respond_to do |format|
      format.html {render layout: false}
      format.js {render layout: false}
    end
  end
end
