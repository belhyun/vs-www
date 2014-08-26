class ErrorsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:send_msg]
  def send_msg
    Error.create(:msg => params[:msg])
  end
end
