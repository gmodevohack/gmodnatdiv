class Cvtermsynonym < ActiveRecord::Base

  set_table_name "cvtermsynonym"
  set_primary_key "cvtermsynonym_id"

  belongs_to :cvterm, :class_name => 'Cvterm', :foreign_key => :cvterm_id

  validates_presence_of( :cvterm_id, :message => "is blank! cvterm must be associated with a cv" )
  validates_presence_of( :synonym, :message => "is blank!")

end
