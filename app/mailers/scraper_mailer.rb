class ScraperMailer < ActionMailer::Base
   default :from => ENV['APPLICATION_FROM_EMAIL']
   default :to => ENV['APPLICATION_ERROR_TO_EMAIL']

   def bank_failes(failed_banks)   
      mail(subject: "Lari Application Scrapper Failed",
         body: "#{failed_banks.join(', ')} have no currency data. Check if the bank web page's changed design and the scrapper needs to be rebuilt.")
   end

end
