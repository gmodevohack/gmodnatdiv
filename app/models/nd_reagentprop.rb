class NdReagentprop < ActiveRecord::Base

  belongs_to :nd_reagent
  belongs_to :cvterm

  validates_presence_of( :reagent_id, :cvterm_id )
end
