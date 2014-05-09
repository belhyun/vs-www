class IssuesController < ApplicationController
  def index
    @issues = Issue.paginate(:page => params[:page], :per_page => 2)
    respond_to do |format|
      format.json{render :json => @issues}
    end
  end
end
