class Admin::BanksController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:admin])
  end
  before_filter :load_admin_assets

  # GET /banks
  # GET /banks.json
  def index
    @banks = Bank.sorted

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @banks }
    end
  end

  # GET /banks/1
  # GET /banks/1.json
  def show
    @bank = Bank.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bank }
    end
  end

  # GET /banks/new
  # GET /banks/new.json
  def new
    @bank = Bank.new

    # create the translation object for however many locales there are
    # so the form will properly create all of the nested form fields
    I18n.available_locales.each do |locale|
      @bank.bank_translations.build(:locale => locale.to_s)
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bank }
    end
  end

  # GET /banks/1/edit
  def edit
    @bank = Bank.find(params[:id])
  end

  # POST /banks
  # POST /banks.json
  def create
    @bank = Bank.new(params[:bank])

    add_missing_translation_content(@bank.bank_translations)

    respond_to do |format|
      if @bank.save
        format.html { redirect_to admin_banks_path, notice: t('app.msgs.success_created', :obj => t('activerecord.models.bank')) }
        format.json { render json: @bank, status: :created, location: @bank }
      else
        format.html { render action: "new" }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /banks/1
  # PUT /banks/1.json
  def update
    @bank = Bank.find(params[:id])

    @bank.assign_attributes(params[:bank])

    add_missing_translation_content(@bank.bank_translations)

    respond_to do |format|
      if @bank.save
        format.html { redirect_to admin_banks_path, notice: t('app.msgs.success_updated', :obj => t('activerecord.models.bank')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /banks/1
  # DELETE /banks/1.json
  def destroy
    @bank = Bank.find(params[:id])
    @bank.destroy

    respond_to do |format|
      format.html { redirect_to admin_banks_url }
      format.json { head :no_content }
    end
  end
end
