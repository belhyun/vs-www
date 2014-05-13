class IssuesController < ApplicationController
  def index
    @issues = Issue.paginate(:page => params[:page], :per_page => 2)
    .as_json(:page => params[:page], :include => [:photos => {:methods => [:medium], :except => [:image_content_type, :image_file_name, :image_file_size, :image_updated_at]}])
    respond_to do |format|
      if is_auth?
        format.json{render :json => success(@issues)}
      else
        format.json{render :json => fail(APP_CONFIG['unauthorized'])}
      end
    end
  end
end
