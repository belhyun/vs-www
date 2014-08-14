class WorksController < InheritedResources::Base

  def index
    render :json => success(Work.all) and return
  end
end
