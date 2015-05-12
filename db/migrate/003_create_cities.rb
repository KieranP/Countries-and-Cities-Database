class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities, force: true do |t|
      t.integer :country_id
      t.string  :name
      t.float   :latitude
      t.float   :longitude
      t.string  :time_zone
      t.text    :translations
    end
  end
end
