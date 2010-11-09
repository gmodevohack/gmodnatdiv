class CvtermDbxref < ActiveRecord::Base
  belongs_to :cvterm, :class_name => 'Cvterm', :foreign_key => :cvterm_id
  belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id

  validates_presence_of( :cvterm_id, :dbxref_id, :message => "must be defined (need to associate CvtermDbxref with a Cvterm object and a Dbxref object" )

  set_table_name "cvterm_dbxref"
  set_primary_key "cvterm_dbxref_id"

end
