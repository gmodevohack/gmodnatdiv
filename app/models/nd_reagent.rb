class NdReagent < ActiveRecord::Base

  belongs_to :cvterm, :foreign_key => 'type_id'
  belongs_to :feature

  has_many :nd_protocol_reagents
  has_many :nd_reagentprops
  has_many :nd_reagent_relationships
  
  validates_presence_of( :name, :type_id )
end
