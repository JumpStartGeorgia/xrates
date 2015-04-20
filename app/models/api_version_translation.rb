class ApiVersionTranslation < ActiveRecord::Base
  belongs_to :api_version

  attr_accessible :page_id, :title, :locale

  validates :title, :presence => true

  def required_data_provided?
    provided = false
    
    provided = self.title.present?
    
    return provided
  end
  
  def add_required_data(obj)
    self.title = obj.title if self.title.blank?
  end
end
