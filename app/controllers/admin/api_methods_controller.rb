class Admin::ApiMethodsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:admin])
  end
  before_filter :load_admin_assets
  before_filter :load_api_version

  # GET /api_methods/1
  # GET /api_methods/1.json
  def show
    @api_method = ApiMethod.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @api_method }
    end
  end

  # GET /api_methods/new
  # GET /api_methods/new.json
  def new
    @api_method = ApiMethod.new

    # create the translation object for however many locales there are
    # so the form will properly create all of the nested form fields
    I18n.available_locales.each do |locale|
      @api_method.api_method_translations.build(:locale => locale.to_s)
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @api_method }
    end
  end

  # GET /api_methods/1/edit
  def edit
    @api_method = ApiMethod.find(params[:id])
  end

  # POST /api_methods
  # POST /api_methods.json
  def create
    @api_method = ApiMethod.new(params[:api_method])

    add_missing_translation_content(@api_method.api_method_translations)

    respond_to do |format|
      if @api_method.save
        format.html { redirect_to admin_api_version_api_method_path(@api_version, @api_method), notice: t('app.msgs.success_created', :obj => t('activerecord.models.api_method')) }
        format.json { render json: @api_method, status: :created, location: @api_method }
      else
        format.html { render action: "new" }
        format.json { render json: @api_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /api_methods/1
  # PUT /api_methods/1.json
  def update
    @api_method = ApiMethod.find(params[:id])

    @api_method.assign_attributes(params[:api_method])

    add_missing_translation_content(@api_method.api_method_translations)

    respond_to do |format|
      if @api_method.save
        format.html { redirect_to admin_api_version_api_method_path(@api_version, @api_method), notice: t('app.msgs.success_updated', :obj => t('activerecord.models.api_method')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @api_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api_methods/1
  # DELETE /api_methods/1.json
  def destroy
    @api_method = ApiMethod.find(params[:id])
    @api_method.destroy

    respond_to do |format|
      format.html { redirect_to admin_api_versions_url }
      format.json { head :no_content }
    end
  end

private

  def load_api_version
    @api_version = ApiVersion.find(params[:api_version_id])

    if @api_version.nil?
      redirect_to admin_api_path, :notice => t('app.msgs.does_not_exist')
    end
  end 

end
