class Cvtermprop < ActiveRecord::Base
  belongs_to :cvterm, :class_name => 'Cvterm', :foreign_key => :cvterm_id

  validates_presence_of( :cvterm_id, :type_id, :message => "is blank! cvtermprop must be associated with a cvterm" )

  set_table_name "cvtermprop"
  set_primary_key "cvtermprop_id"
end
