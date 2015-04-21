class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:admin])
  end
  before_filter :load_admin_assets

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pages }
    end
  end

end
