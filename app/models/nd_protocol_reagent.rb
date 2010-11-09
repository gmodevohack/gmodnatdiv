class NdProtocolReagent < ActiveRecord::Base

  belongs_to :cvterm, :foreign_key => 'type_id'
  belongs_to :nd_protocol
  belongs_to :nd_reagent

  validates_presence_of :protocol_id, :reagent_id, :type_id
end
