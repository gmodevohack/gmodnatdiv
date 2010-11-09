class Cvtermpath < ActiveRecord::Base
  
  belongs_to :cv, :class_name => 'Cv', :foreign_key => :cv_id

  # TODO: reconsider relationship names -- CHECK 
  belongs_to :cvterm_subject, :foreign_key => "subject_id"
  belongs_to :cvterm_object, :foreign_key => "object_id"

  validates_presence_of( :subject_id, :object_id, :cv_id, :message => "must be defined. Use add_* to add subject (a cvterm object), object (also a cvterm object) or cv (a cv object)" )

  set_table_name "cvtermpath"
  set_primary_key "cvtermpath_id"

end
