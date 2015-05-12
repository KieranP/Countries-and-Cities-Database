require './app'
require 'csv'
require 'iso3166'

#
# CONFIG OPTIONS STARTS
#

COUNTRIES_FOLDER = "GeoLite2-Country-CSV_20150505"
COUNTRIES_FILE = "GeoLite2-Country-Locations-en.csv"

CITIES_FOLDER1 = "GeoLite2-City-CSV_20150505"
CITIES_FILE1 = "GeoLite2-City-Locations-en.csv"

CITIES_FOLDER2 = "GeoLiteCity_20150505"
CITIES_FILE2 = "GeoLiteCity-Location.csv"

#
# CONFIG OPTIONS FINISHED
#

continents = Hash[Continent.all.collect { |c| [c.code, c] }]
countries = Hash[Country.all.collect { |c| [c.alpha2, c] }]
cities = Hash[City.includes(:country).collect { |c| ["#{c.country.alpha2}-#{c.name}", c] }]
currencies = Hash[Currency.all.collect { |c| [c.code, c] }]

#
# Parse Continents and Countries
#

index = 0
puts "Parsing Continents & Countries"
CSV.foreach("vendor/#{COUNTRIES_FOLDER}/#{COUNTRIES_FILE}", :encoding => "UTF-8") do |row|
  if index.zero?
    index += 1
    next
  end

  continent_code = row[2]
  continent_name = row[3]
  country_code = row[4]
  country_name = row[5]

  next if country_name.blank?

  attrs = {
    name: continent_name,
    code: continent_code
  }

  if continent = continents[continent_code]
    continent.attributes = attrs
    continent.save! if continent.changed?
  else
    continent = Continent.create!(attrs)
    continents[continent_code] = continent
  end

  data = ISO3166::Country[country_code]

  currency = nil
  if data.try(:currency)
    attrs = {
      name: data.currency.name,
      code: data.currency.code,
      symbol: data.currency.symbol
    }

    if currency = currencies[data.currency.code]
      currency.attributes = attrs
      currency.save! if currency.changed?
    else
      currency = Currency.create!(attrs)
      currencies[data.currency.code] = currency
    end
  end

  attrs = {
    name: country_name,
    alpha2: country_code,
    alpha3: data.try(:alpha3),
    country_code: data.try(:country_code),
    world_region: data.try(:world_region),
    region: data.try(:region),
    subregion: data.try(:subregion),
    latitude: data.try(:latitude),
    longitude: data.try(:longitude),
    translations: data.try(:translations),
    currency: currency
  }

  if country = countries[country_code]
    country.attributes = attrs
    country.save! if country.changed?
  else
    country = continent.countries.create!(attrs)
    countries[country_code] = country
  end

  index += 1
  print "." if (index % 5).zero?
end

#
# Parse Cities & Timezones
#

index = 0
puts "\n\n"
puts "Parsing Cities & Timezones"
CSV.foreach("vendor/#{CITIES_FOLDER1}/#{CITIES_FILE1}", :encoding => "UTF-8") do |row|
  if index.zero?
    index += 1
    next
  end

  country_code = row[4]
  city_name = row[10]
  time_zone = row[12]

  next if city_name.blank?
  country = countries[country_code]
  next if country.blank?

  attrs = {
    name: city_name,
    time_zone: time_zone
  }

  city_key = "#{country.alpha2}-#{city_name}"
  if city = cities[city_key]
    city.attributes = attrs
    city.save! if city.changed?
  else
    city = country.cities.create!(attrs)
    cities[city_key] = city
  end

  index += 1
  print "." if (index % 1000).zero?
end

#
# Parse City Latitudes & Logitudes
#

index = 0
puts "\n\n"
puts "Parsing City Latitudes & Longitudes"
CSV.foreach("vendor/#{CITIES_FOLDER2}/#{CITIES_FILE2}", :encoding => "ISO-8859-1") do |row|
  if index <= 1
    index += 1
    next
  end

  country_code = row[1]
  city_name = row[3]
  latitude = row[5]
  longitude = row[6]

  next if city_name.blank?
  country = countries[country_code]
  next if country.blank?

  city_key = "#{country.alpha2}-#{city_name}"
  if city = cities[city_key]
    next if city.latitude? && city.longitude?

    city.latitude = latitude
    city.longitude = longitude
    city.save!
  end

  index += 1
  print "." if (index % 1000).zero?
end

puts "\n\n"
puts "Finished parsing data!"
puts ""
