require './app'
require 'csv'

CSV.open("countries.csv", "wb") do |csv|
  csv << ["Name", "Alpha2", "Alpha3", "Continent", "World Region", "Region",
    "Subregion", "Latitude", "Longitude", "Currency Code", "Currency Symbol"]

  Country.all.sort_by(&:name).each do |country|
    next unless country.name.present? && country.alpha3.present?
    csv << [country.name, country.alpha2, country.alpha3, country.continent.name,
      country.world_region, country.region, country.subregion, country.latitude,
      country.longitude, country.currency.try(:code), country.currency.try(:symbol)]
  end
end

CSV.open("cities.csv", "wb") do |csv|
  csv << ["Name", "Country", "Latitude", "Longitude", "Time Zone"]

  City.all.sort_by(&:name).each do |city|
    next unless city.name.present? && city.time_zone.present?
    csv << [city.name, city.country.name, city.latitude, city.longitude, city.time_zone]
  end
end
