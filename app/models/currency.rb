class Currency < ActiveRecord::Base
   translates :name

  has_many :currency_translations, :dependent => :destroy
  accepts_nested_attributes_for :currency_translations
  attr_accessible :id, :name, :currency_translations_attributes
  
  validates :name, :presence => true

  def self.by_name(name)
    with_translations(I18n.locale).find_by_name(name)
  end
  def self.select_list()
    with_translations(I18n.locale).map{|x| [x.code, x.name] }.sort_by{|x| x[0]}
  end
  def self.data()
    with_translations(I18n.locale).map{|x| [x.code, x.name, x.ratio] }.sort_by{|x| x[0]}
  end

  def self.available()
      with_translations(I18n.locale).where({ code: Rate.bank_currencies.map{|x| x.currency }}).map{|x| [x.code, x.name, x.ratio] }.sort_by{|x| x[0]}
  end
end

