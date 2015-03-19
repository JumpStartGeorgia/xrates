class RootController < ApplicationController

  def index
    params[:currency] ||= 'USD'
    gon.currency = params[:currency]
    @currencies = Currency.data 

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  def compare
    params[:currency] ||= 'USD'
    params[:bank] ||= '2'
    gon.currency = params[:currency]
    gon.bank = params[:bank]
    @currencies = Currency.available
    @banks = Bank.all_except_nbg

    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
