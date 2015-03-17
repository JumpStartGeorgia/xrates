class CurrencyTranslation < ActiveRecord::Base
  belongs_to :currency

  attr_accessible :currency_id, :name, :locale

  validates :name, :presence => true
end
