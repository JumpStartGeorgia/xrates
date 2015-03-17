class Rate < ActiveRecord::Base
  attr_accessible :currency, :date, :rate, :buy_price, :sell_price, :utc
  belongs_to :bank
  ########################
  ## Validations
  validates :currency, :date, :rate, :presence => true
  validates :currency, uniqueness: { scope: :date}

  ########################
  ## Scopes
  scope :by_currency, -> currency { where(currency: currency) if currency.present? }
  scope :start_date, -> start_date { where("date >= ?", start_date) if start_date.present? }
  scope :end_date, -> end_date { where("date <= ?", end_date) if end_date.present? }
  scope :sort_recent, -> { order("rates.date DESC") }
  scope :sort_older, -> { order("rates.date ASC") }
  scope :limit_by, -> limit { limit(limit) if limit.present? }

  ########################

  # if the rate does not exist, add it, else update it
  def self.create_or_update(date, currency, rate)
    x = where(:date => date, :currency => currency).first
    
    if x.blank?
      date_parts = date.split('-')
      x = Rate.new(date: date, currency: currency, utc: Time.utc(date_parts[0], date_parts[1], date_parts[2]))
    end
    
    x.rate = rate
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

  # get the utc and rates for a currency
  # return: [ [utc, rate], [utc, rate], ...]
  def self.utc_and_rates(currency)
    select('rate, utc').by_currency(currency).sort_older.map{|x| [x.utc.to_i*1000, x.rate]}
  end

  # get list of currencies
  def self.currencies
    pluck(:currency).uniq.sort
  end
end
