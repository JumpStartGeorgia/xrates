class ApiVersion < ActiveRecord::Base
  translates :title

  has_many :api_methods, dependent: :destroy
  has_many :api_version_translations, :dependent => :destroy
  accepts_nested_attributes_for :api_version_translations
  attr_accessible :permalink, :public, :public_at, :api_version_translations_attributes
  
  validates :permalink, :presence => true

  #############################
  # Callbacks
  before_save :set_public_at

  # if public and public at not exist, set it
  # else, make nil
  def set_public_at
    if self.public? && self.public_at.nil?
      self.public_at = Time.now.to_date
    elsif !self.public?
      self.public_at = nil
    end
  end

  #############################

  def self.is_public
    where(public: true)
  end

  def self.sorted
    with_translations(I18n.locale).order('api_versions.public_at asc, api_version_translations.title asc')
  end

  def self.by_permalink(permalink)
    find_by_permalink(permalink)
  end
end
