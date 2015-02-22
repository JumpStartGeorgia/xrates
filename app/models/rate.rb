class Rate < ActiveRecord::Base
  attr_accessible :currency, :date, :rate

  ########################
  ## Validations
  validates :currency, :date, :rate, :presence => true
  validates :currency, uniqueness: { scope: :date}

  ########################
  ## Scopes
  scope :by_currency, -> currency { where(currency: currency) if currency.present? }
  scope :start_date, -> start_date { where("date >= ?", start_date) if start_date.present? }
  scope :end_date, -> end_date { where("date <= ?", end_date) if end_date.present? }
  scope :sort_by_date, -> { order("rates.date DESC") }
  scope :limit_by, -> limit { limit(limit) if limit.present? }


  ########################

  # if the rate does not exist, add it, else update it
  def self.create_or_update(date, currency, rate)
    x = where(:date => date, :currency => currency).first
    
    if x.blank?
      x = Rate.new(date: date, currency: currency)
    end
    
    x.rate = rate
    x.save
  end
end
