class NdGeolocationprop < ActiveRecord::Base

  belongs_to :cvterm
  belongs_to :nd_geolocation

  validates_presence_of( :nd_geolocation_id, :type_id )
end
