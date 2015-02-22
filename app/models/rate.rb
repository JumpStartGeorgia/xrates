class Rate < ActiveRecord::Base
  attr_accessible :currency, :date, :rate

  scope :by_currency, -> currency { where(currency: currency) if currency.present? }
  scope :start_date, -> start_date { where("date >= ?", start_date) if start_date.present? }
  scope :end_date, -> end_date { where("date <= ?", end_date) if end_date.present? }
  scope :sort_by_date, -> { order("rates.date DESC") }
  scope :limit_by, -> limit { rates.limit(limit) if limit.present? }

end
