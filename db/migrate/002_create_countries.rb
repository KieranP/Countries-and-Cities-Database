class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries, force: true do |t|
      t.integer :continent_id
      t.integer :currency_id
      t.string  :name
      t.string  :alpha2
      t.string  :alpha3
      t.string  :country_code
      t.string  :world_region
      t.string  :region
      t.string  :subregion
      t.float   :latitude
      t.float   :longitude
      t.text    :translations
    end
  end
end
