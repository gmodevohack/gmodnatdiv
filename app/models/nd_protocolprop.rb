class NdProtocolprop < ActiveRecord::Base

  belongs_to :nd_protocol
  belongs_to :cvterm

  validates_presence_of( :protocol_id, :cvterm_id )
end
