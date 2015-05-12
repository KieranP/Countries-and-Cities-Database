require 'active_record'
require 'sqlite3'
require 'logger'

ActiveRecord::Base.logger = Logger.new('log/development.log')
configuration = YAML::load(IO.read('config/database.yml'))
ActiveRecord::Base.establish_connection(configuration['development'])

class Continent < ActiveRecord::Base
  has_many :countries, dependent: :destroy
  serialize :translations

  # t.string :name
  # t.string :code
  # t.text   :translations
end

class Country < ActiveRecord::Base
  belongs_to :continent
  belongs_to :currency
  has_many :cities, dependent: :destroy
  serialize :translations

  # t.integer :continent_id
  # t.integer :currency_id
  # t.string  :name
  # t.string  :alpha2
  # t.string  :alpha3
  # t.string  :country_code
  # t.string  :world_region
  # t.string  :region
  # t.string  :subregion
  # t.float   :latitude
  # t.float   :longitude
  # t.text    :translations
end

class City < ActiveRecord::Base
  belongs_to :country
  serialize :translations

  # t.integer :country_id
  # t.string  :name
  # t.float   :latitude
  # t.float   :longitude
  # t.string  :time_zone
  # t.text    :translations
end

class Currency < ActiveRecord::Base
  has_many :countries, dependent: :destroy

  # t.string  :name
  # t.string  :code
  # t.string  :symbol
end
