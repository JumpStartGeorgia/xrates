class Admin::PageContentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:admin])
  end
  before_filter :load_admin_assets

  # GET /pages
  # GET /pages.json
  def index
    @page_contents = PageContent.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @page_contents }
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    @page_content = PageContent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page_content }
    end
  end

  # GET /pages/new
  # GET /pages/new.json
  def new
    @page_content = PageContent.new

    # create the translation object for however many locales there are
    # so the form will properly create all of the nested form fields
    I18n.available_locales.each do |locale|
      @page_content.page_content_translations.build(:locale => locale.to_s)
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @page_content }
    end
  end

  # GET /pages/1/edit
  def edit
    @page_content = PageContent.find(params[:id])
  end

  # POST /pages
  # POST /pages.json
  def create
    @page_content = PageContent.new(params[:page_content])

    add_missing_translation_content(@page_content.page_content_translations)

    respond_to do |format|
      if @page_content.save
        format.html { redirect_to admin_page_content_path(@page_content), notice: t('app.msgs.success_created', :obj => t('activerecord.models.page_content')) }
        format.json { render json: @page_content, status: :created, location: @page_content }
      else
        format.html { render action: "new" }
        format.json { render json: @page_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.json
  def update
    @page_content = PageContent.find(params[:id])

    @page_content.assign_attributes(params[:page_content])

    add_missing_translation_content(@page_content.page_content_translations)

    respond_to do |format|
      if @page_content.save
        format.html { redirect_to admin_page_content_path(@page_content), notice: t('app.msgs.success_updated', :obj => t('activerecord.models.page_content')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @page_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page_content = PageContent.find(params[:id])
    @page_content.destroy

    respond_to do |format|
      format.html { redirect_to admin_page_contents_url }
      format.json { head :no_content }
    end
  end
end
