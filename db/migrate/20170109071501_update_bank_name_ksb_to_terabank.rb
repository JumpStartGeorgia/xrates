class UpdateBankNameKsbToTerabank < ActiveRecord::Migration
  def up
    b = Bank.find(10)
    b.name_translations = {"en"=>"Terabank", "ka"=>"ტერაბანკი"}
    b.save
  end

  def down # old bank icon name is _ksb
    b = Bank.find(10)
    b.name_translations = {"en"=>"KSB", "ka"=>"კორ სტანდარტ ბანკი"}
    b.save
  end
end
