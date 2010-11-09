class CvtermRelationship < ActiveRecord::Base

  set_table_name "cvterm_relationship"
  set_primary_key "cvterm_relationship_id"

  belongs_to :parent, :class_name => "Cvterm"
  belongs_to :child, :class_name => "Cvterm"

  before_save :set_type_id

  # validates_presence_of( :type_id, :message => "must be defined (need to associate CvtermDbxref with a Cvterm object and a Dbxref object" )
  validates_presence_of( :subject_id, :object_id, :message => "must be defined (need to associate CvtermDbxref with a Cvterm object and a Dbxref object" )

  def set_type_id
    self.type_id = "child" if self.type_id.nil?
  end

end
