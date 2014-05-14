class IssuesController < ApplicationController
  def index
    @issues = Issue.paginate(:page => params[:page], :per_page => Issue::PER_PAGE)
    .as_json(:include => [:photos => {:methods => [:medium], :except => [:image_content_type, :image_file_name, :image_file_size, :image_updated_at]}])
    respond_to do |format|
      if is_auth?
        @success = success(@issues)
        @success[:total_cnt] = Issue.count
        @success[:per_page] = Issue::PER_PAGE
        @success[:page] = params[:page].to_i
        format.json{render :json => @success}
      else
        format.json{render :json => fail(APP_CONFIG['unauthorized'])}
      end
    end
  end
end
