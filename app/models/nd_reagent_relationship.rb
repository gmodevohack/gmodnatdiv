class NdReagentRelationship < ActiveRecord::Base
  belongs_to :cvterm, :foreign_key => 'type_id'
  belongs_to :parent, :class_name => "NdReagent"
  belongs_to :child, :class_name => "NdReagent"

  validates_presence_of :object_reagent_id, :subject_reagent_id, :type_id

end
