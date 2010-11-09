class Study < ActiveRecord::Base
    belongs_to :contact, :class_name => 'Contact', :foreign_key => :contact_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
    has_many :study_assays , :foreign_key => :study_id
    has_many :assays 
    has_many :studydesigns , :foreign_key => :study_id
    has_many :studyprops , :foreign_key => :study_id
    
end
