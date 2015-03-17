class BankTranslation < ActiveRecord::Base
  belongs_to :bank

  attr_accessible :bank_id, :name, :image, :locale

  validates :name, :presence => true
end
