class Dbxrefprop < ActiveRecord::Base
 
  set_table_name "dbxrefprop"
  set_primary_key "dbxrefprop_id"

  belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
  belongs_to :cvterm, :foreign_key => "type_id"

  validates_presence_of( :dbxref_id, :type_id, :message => "is blank! dbxrefprop must be associated with a dbxref" )
 
end
