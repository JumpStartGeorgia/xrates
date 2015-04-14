class ScraperMailer < ActionMailer::Base
   default :from => ENV['LARI_APPLICATION_FROM_EMAIL']
   default :to => ENV['LARI_APPLICATION_TO_EMAIL']

   def bank_failes(failed_banks)   
      mail(subject: "Lari Application Scrapper Failed",
         body: "#{failed_banks.join(', ')} have no currency data. Check changes in page layout for banks.")
   end

end
