class Bank < ActiveRecord::Base
   translates :name, :image
  has_many :bank_translations, :dependent => :destroy
  has_many :rates
  accepts_nested_attributes_for :bank_translations
  attr_accessible :id, :code, :name, :image, :bank_translations_attributes
  
  validates :code, :presence => true
  validates :name, :presence => true
  validates :image, :presence => true

  def self.by_name(name)
    with_translations(I18n.locale).find_by_name(name)
  end

end

