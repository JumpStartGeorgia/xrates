class RootController < ApplicationController

  def index
    params[:currency] ||= 'USD,EUR,GBP,RUB'
    params[:bank] ||= 'BNLN'    
    gon.currency = params[:currency]
    gon.bank = params[:bank]
    @currencies = Currency.data 
    @currencies_available = Currency.available
    @banks = Bank.all_except_nbg
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
