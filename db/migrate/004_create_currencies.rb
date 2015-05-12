class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies, force: true do |t|
      t.string  :name
      t.string  :code
      t.string  :symbol
    end
  end
end
