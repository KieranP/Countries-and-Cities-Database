class CreateContinents < ActiveRecord::Migration
  def change
    create_table :continents, force: true do |t|
      t.string :name
      t.string :code
      t.text   :translations
    end
  end
end
