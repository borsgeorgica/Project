require 'geokit-rails'

class Location < ActiveRecord::Base
    
  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng
end

Location.in_range(5, :origin => '100 Spear st, San Francisco, CA')
