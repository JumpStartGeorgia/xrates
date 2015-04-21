class ApiMethod < ActiveRecord::Base
  translates :title, :content

  belongs_to :api_version

  has_many :api_method_translations, :dependent => :destroy
  accepts_nested_attributes_for :api_method_translations
  attr_accessible :permalink, :public, :public_at, :api_method_translations_attributes
  attr_accessible :api_version_id, :permalink, :public, :public_at, :sort_order
  
  validates :api_version_id, :permalink, :presence => true
  validates_uniqueness_of :permalink, scope: :api_version_id

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
    with_translations(I18n.locale).order('api_methods.sort_order asc, api_method_translations.title asc')
  end

  def self.by_permalink(api_version_id, permalink)
    where(permalink: permalink, api_version_id: api_version_id).first
  end


end
