class RootController < ApplicationController

  def index
    params[:currency] ||= 'USD'
    @currencies = Rate.currencies

    # get chart data
    gon.chart_rates = Rate.by_currency(params[:currency]).sort_older.rate_only
    start_date = Rate.start_date(params[:currency])
    gon.chart_start_date_year = start_date.year
    gon.chart_start_date_month = start_date.month
    gon.chart_start_date_day = start_date.day
    gon.chart_currency = params[:currency]
    gon.chart_title = "Lari to #{params[:currency]} exchange rate from #{start_date.year} to Present Day"
    gon.chart_yaxis = "Exchange Rate"
    gon.chart_popup = "Lari to #{params[:currency]}"

    # get highstock data
    gon.stock_rates = Rate.utc_and_rates(params[:currency])
    gon.stock_currency = params[:currency]
    gon.stock_title = "Lari to #{params[:currency]} exchange rate from #{start_date.year} to Present Day"
    gon.stock_yaxis = "Exchange Rate"
    gon.stock_popup = "Lari to #{params[:currency]}"


    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
