class ApiController < ApplicationController

  def index
    @tab=4

    @page_content = Page.by_name('api')
    @api_versions = ApiVersion.is_public.sorted

    @css.push('api.css')
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
