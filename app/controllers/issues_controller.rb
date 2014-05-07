class IssuesController < ApplicationController
  def index
    @issues = Issue.paginate(:page => params[:page], :per_page => 2)
    render :json => @issues
  end
end
