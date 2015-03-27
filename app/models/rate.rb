class Rate < ActiveRecord::Base
  attr_accessible :currency, :date, :rate, :buy_price, :sell_price, :utc, :bank_id
  belongs_to :bank
  ########################
  ## Validations
  validates :currency, :date, :presence => true
  validates :rate, presence: true, if: :nbg?
  validates :buy_price, :sell_price, presence: true, if: :not_nbg?
  validates :currency, uniqueness: { scope: [:date, :bank_id] }

  ########################
  ## Scopes
  scope :by_currency, -> currency { where(currency: currency) if currency.present? }
  scope :by_bank, -> bank_id { where(bank_id: bank_id) if bank_id.present? }
  scope :only_nbg, -> { where("bank_id = 1") }
  scope :nbg_by_period, -> (from, to) { where("bank_id = 1 and date >= ?",from).where("date <= ?",to) if from.present? && to.present? }
  scope :not_nbg, -> { where("bank_id != 1") }
  scope :start_date, -> start_date { where("date >= ?", start_date) if start_date.present? }
  scope :end_date, -> end_date { where("date <= ?", end_date) if end_date.present? }
  scope :sort_recent, -> { order("rates.date DESC") }
  scope :sort_older, -> { order("rates.date ASC") }
  scope :limit_by, -> limit { limit(limit) if limit.present? }
  scope :bank_currencies, -> { select("DISTINCT currency").where("bank_id != 1") }

  ########################

  # if the rate does not exist, add it, else update it
  def self.create_or_update(date, currency, rate, buy_price, sell_price, bank_id)
    x = where(:date => date, :currency => currency, :bank_id => bank_id).first
    if x.blank?
      x = Rate.new(date: date, currency: currency, utc: Time.utc(date.year, date.month, date.day, 0,0,0), bank_id: bank_id)
    end
    
    x.rate = rate
    x.buy_price = buy_price
    x.sell_price = sell_price
    x.save
  end

  # get the starting date for the provided currency
  def self.start_date(currency)
    x = where(currency: currency).sort_older.first
    if x.present?
      x.date
    else
      nil
    end
  end

  # get the starting date for the provided currency
  def self.end_date(currency)
    x = where(currency: currency).sort_recent.first
    if x.present?
      x.date
    else
      nil
    end
  end

  # return an array of rates
  def self.rate_only
    pluck(:rate)
  end

  
  def self.nbg_rates(cur,from,to)
     Rails.logger.debug("--------------------------------------------#{cur}#{from}#{to}")
    select('rate, utc').nbg_by_period(from,to).by_currency(cur).sort_older.map{|x| [x.utc.to_i*1000, x.rate]}
  end



  # get the utc and rates for a currency
  # return: [ [utc, rate], [utc, rate], ...]
  def self.utc_and_rates(currency)
    select('rate, utc').only_nbg.by_currency(currency).sort_older.map{|x| [x.utc.to_i*1000, x.rate]}
  end

  def self.rates_nbg(currency,bank)
      select('rate, utc').where('date > ?','2015-03-15').by_currency(currency).by_bank(bank).sort_older.map{|x| [x.utc.to_i*1000, x.rate]}
  end
  def self.rates_buy(currency,bank)
      c = Currency.find_by_code(currency)
      select('buy_price, utc').where('date > ?','2015-03-15').by_currency(currency).by_bank(bank).sort_older.map{|x| [x.utc.to_i*1000, x.buy_price*c.ratio]}
  end
  def self.rates_sell(currency,bank)
      c = Currency.find_by_code(currency)
      select('sell_price, utc').where('date > ?','2015-03-15').by_currency(currency).by_bank(bank).sort_older.map{|x| [x.utc.to_i*1000, x.sell_price*c.ratio]}
  end

  def nbg?
    bank_id == 1
  end
  def not_nbg?
    !nbg?
  end
end
