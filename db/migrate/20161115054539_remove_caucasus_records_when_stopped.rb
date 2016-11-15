class RemoveCaucasusRecordsWhenStopped < ActiveRecord::Migration
  def up
    # Caucasus Development Bank Georgia was not updating currencies on there site
    # from 03.09.2016-15.11.2016, and after that period domain was switched off
    # original values:
    # 2016-09-02 00:00:00 USD 2.26 2.31
    # 2016-08-23 00:00:00 EUR 2.53 2.63
    # 2016-09-02 00:00:00 GBP 2.95 3.15
    dt = DateTime.new(2016,9,3)
    dls = Rate.where("bank_id = 18 and utc >= ?", dt).delete_all
    puts "#{dls} records were deleted"
  end

  def down
    from = Date.new(2016,9,3)
    to = Date.new(2016,11,15)
    i = 0
    from.upto(to) do |dt|
      Rate.create_or_update(dt, "USD", nil, 2.26, 2.31, 18)
      Rate.create_or_update(dt, "EUR", nil, 2.53, 2.63, 18)
      Rate.create_or_update(dt, "GBP", nil, 2.95, 3.15, 18)
      i += 1
    end
    puts "#{i*3} records were reverted"
  end
end


