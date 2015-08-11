class ScraperMailer < ActionMailer::Base
   default :from => ENV['APPLICATION_FEEDBACK_FROM_EMAIL']
   default :to => ENV['APPLICATION_ERROR_TO_EMAIL']

   def banks_failed(failed_banks)
      mail(subject: "Lari Application Scrapper Failed (#{Rails.env})",
         body: "The following banks had no currenty data: \n\n - #{failed_banks.join("\n - ")}. \n\nCheck if the bank web page's changed design and the scrapper needs to be rebuilt.")
   end

   def banks_processed(processed_banks)
      mail(subject: "Lari Application Scrapper Update (#{Rails.env})",
         body: "Here are the results of the latest scrape: \n\n - #{processed_banks.join("\n - ")}")
   end

   def report_error(e)
      mail(subject: "Lari Application Scrapper Error (#{Rails.env})",
         body: "The following error occurred: \n\n#{e}  \n\nCheck the log for where the error occurred.")
   end

end
