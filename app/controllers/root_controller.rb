class RootController < ApplicationController

  def index
    params[:currency] ||= 'USD'
    @currencies = Rate.currencies
    gon.rates = Rate.by_currency(params[:currency]).sort_older.rate_only
    start_date = Rate.start_date(params[:currency])
    gon.start_date_year = start_date.year
    gon.start_date_month = start_date.month
    gon.start_date_day = start_date.day
    gon.currency = params[:currency]
    gon.title = "Lari to #{params[:currency]} exchange rate from #{start_date.year} to Present Day"
    gon.yaxis = "Exchange Rate"
    gon.popup = "Lari to #{params[:currency]}"

    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
