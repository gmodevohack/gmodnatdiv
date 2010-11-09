class StudyAssay < ActiveRecord::Base
    belongs_to :study, :class_name => 'Study', :foreign_key => :study_id
    belongs_to :assay, :class_name => 'Assay', :foreign_key => :assay_id
    
end
