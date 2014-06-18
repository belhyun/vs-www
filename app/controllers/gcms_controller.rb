class GcmsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:reg, :send]
  def reg
    if @user_id.nil?
      render :json =>fail(Code::MSG[:user_not_found]) and return
    end

    if User.update(@user_id, :gcm_id => gcm_params[:gcm_id])
      render :json =>success(nil)
    else
      render :json =>fail()
    end
  end

  def send_msg
    gcm = GCM.new(APP_CONFIG['gcm_api_key'])
    if gcm.nil?
      render :json => fail(Code::MSG[:transaction_fail])
    end
    reg_ids = User.all.select(:gcm_id).reject{|a|a[:gcm_id].nil?}.map{|user| user.gcm_id}
    options = {
      data: {
        :hello => "world"
      },
      :collapse_key => "vs project notification"
    }
    response = gcm.send_notification(reg_ids, options)
    if response[:status_code] == 200 && response[:response] == "success"
      render :json =>  success(Code::MSG[:gcm_send_success]) and return
    end
    render :json => fail(Code::MSG[:gcm_send_fail]) and return
  end
end