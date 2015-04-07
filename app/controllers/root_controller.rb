class RootController < ApplicationController

  def index

    @js.push("u.js", "root.js") 
    @tab=1
    
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
  def api
    @tab=4
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
  def about   
    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
