class Admin::ApiVersionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:admin])
  end
  before_filter :load_admin_assets

  # GET /api_versions
  # GET /api_versions.json
  def index
    @api_versions = ApiVersion.sorted

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @api_versions }
    end
  end

  # GET /api_versions/new
  # GET /api_versions/new.json
  def new
    @api_version = ApiVersion.new

    # create the translation object for however many locales there are
    # so the form will properly create all of the nested form fields
    I18n.available_locales.each do |locale|
      @api_version.api_version_translations.build(:locale => locale.to_s)
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @api_version }
    end
  end

  # GET /api_versions/1/edit
  def edit
    @api_version = ApiVersion.find(params[:id])
  end

  # POST /api_versions
  # POST /api_versions.json
  def create
    @api_version = ApiVersion.new(params[:api_version])

    add_missing_translation_content(@api_version.api_version_translations)

    respond_to do |format|
      if @api_version.save
        format.html { redirect_to admin_api_versions_path, notice: t('app.msgs.success_created', :obj => t('activerecord.models.api_version')) }
        format.json { render json: @api_version, status: :created, location: @api_version }
      else
        format.html { render action: "new" }
        format.json { render json: @api_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /api_versions/1
  # PUT /api_versions/1.json
  def update
    @api_version = ApiVersion.find(params[:id])

    @api_version.assign_attributes(params[:api_version])

    add_missing_translation_content(@api_version.api_version_translations)

    respond_to do |format|
      if @api_version.save
        format.html { redirect_to admin_api_versions_path, notice: t('app.msgs.success_updated', :obj => t('activerecord.models.api_version')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @api_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api_versions/1
  # DELETE /api_versions/1.json
  def destroy
    @api_version = ApiVersion.find(params[:id])
    @api_version.destroy

    respond_to do |format|
      format.html { redirect_to admin_api_versions_url }
      format.json { head :no_content }
    end
  end
end
