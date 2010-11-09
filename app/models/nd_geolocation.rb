class NdGeolocation < ActiveRecord::Base

  has_many :nd_experiments
  has_many :nd_geolocationprops

end
