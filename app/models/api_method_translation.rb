class ApiMethodTranslation < ActiveRecord::Base
  belongs_to :api_method

  attr_accessible :page_id, :title, :content, :locale

  validates :title, :content, :presence => true

  def required_data_provided?
    provided = false
    
    provided = self.title.present? && self.content.present?
    
    return provided
  end
  
  def add_required_data(obj)
    self.title = obj.title if self.title.blank?
    self.content = obj.content if self.content.blank?
  end
end
