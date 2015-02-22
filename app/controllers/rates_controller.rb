class RatesController < ApplicationController
	before_filter :authenticate_user!, :except => :index
  before_filter :except => :index do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:admin])
  end

  def index

    currency = params['currency'] if params['currency']
  	start_date = params['start_date'] if  params['start_date']
  	end_date = params['end_date'] if  params['end_date']
  	limit = params['limit_by'].to_i if params['limit_by']

    @rates = Rate.by_currency(currency).start_date(start_date).end_date(end_date).sort_by_date.limit_by(limit)
    
    respond_to do |format|
     format.html {}
     format.json { render json: @rates, :only => [:date, :currency, :rate] }
    end
  end

	def new
    @rate = Rate.new
  end
  
  def create(data)
    @rate = Rate.new(data)
    @rate.save
  end
end
