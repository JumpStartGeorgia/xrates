class Bank < ActiveRecord::Base
   translates :name, :image
  has_many :bank_translations, :dependent => :destroy
  has_many :rates
  accepts_nested_attributes_for :bank_translations
  attr_accessible :id, :code, :name, :image, :bank_translations_attributes, :order, :org_type # org_type 0 bank 1 other

  validates :code, :presence => true
  validates :name, :presence => true
  validates :image, :presence => true
  validates :org_type, :presence => true

  scope :not_nbg, -> { where("banks.id != 1") }

  def self.by_name(name)
    with_translations(I18n.locale).find_by_name(name)
  end

  def self.all_except_nbg()
      with_translations(I18n.locale).where("code != 'BNLN'").map{ |x| [x.id, x.name, x.buy_color, x.sell_color, x.code, x.image, x.org_type ] }.sort_by{|x| x[0] }
  end

  def self.sorted
    with_translations(I18n.locale).order('`order` asc')
  end
end

