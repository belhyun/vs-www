class VersionsController < ApplicationController
  def index
    render :json => Version.first
  end
end
