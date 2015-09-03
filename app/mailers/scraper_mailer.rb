class ScraperMailer < ActionMailer::Base
   default :from => ENV['APPLICATION_FEEDBACK_FROM_EMAIL']
   default :to => ENV['APPLICATION_ERROR_TO_EMAIL']

   # def banks_failed(failed_banks)
   #    mail(subject: "Lari Application Scrapper Failed (#{Rails.env})",
   #       body: "The following banks had no currenty data: \n\n - #{failed_banks.join("\n - ")}. \n\nCheck if the bank web page's changed design and the scrapper needs to be rebuilt.")
   # end

   # def banks_processed(processed_banks)
   #    mail(subject: "Lari Application Scrapper Update (#{Rails.env})",
   #       body: "Here are the results of the latest scrape: \n\n - #{processed_banks.join("\n - ")}")
   # end



   def report(successful, unexpected, with_exception)
      successful.map! {|d| "\t" + d }
      unexpected.map! {|d| "\t" + d }
      with_exception.map! {|d| "\t" + d }
      bd = "Here are the results of the latest scrape:\n\n"
      bd = bd + "Successfully loaded banks:\n\n#{successful.join("\n")}\n\n" if successful.any?
      bd = bd + "Unexpected amount of currency for banks:\n\n#{unexpected.join("\n")}\n\n" if unexpected.any?
      bd = bd + "Banks with exceptions:\n\n#{with_exception.join("\n")}" if with_exception.any?

      mail(subject: "Lari Application Scrapper Report (#{Rails.env})", body: bd)
   end

   def unexpected(banks)
      banks.map! {|d| "\t" + d }
      mail(
         subject: "Lari Application Scrapper Unexpected Behavior (#{Rails.env})",
         body: "The following banks scraped currency count is not equal to threshold value for this bank: \n\n#{banks.join("\n")}\n\nCheck bank site, if structure was changed or new currency was added.")
   end

   def exception(banks)
      banks.map! {|d| "\t" + d }
      mail(
         subject: "Lari Application Scrapper Exceptions (#{Rails.env})",
         body: "The following banks scraping stopped with exceptions: \n\n#{banks.join("\n")}
               \n\nCheck if the bank web page's changed design and the scrapper needs to be rebuilt.")
   end

   def sending_failed(e)
      mail(
         subject: "Lari Application Scrapper Report Sending Error (#{Rails.env})",
         body: "The following error occurred: \n\n#{e}  \n\nCheck the log for where the error occurred.")
   end

end
