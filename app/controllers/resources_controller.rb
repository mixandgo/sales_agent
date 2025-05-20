class ResourcesController < ApplicationController
  def create
    Resource.create!(resource_params)
    redirect_to root_path
  end

  def destroy
    Resource.find(params[:id]).destroy
    redirect_to root_path
  end

  private
    def resource_params
      params.expect(resource: [ :name, :file ])
    end
end
