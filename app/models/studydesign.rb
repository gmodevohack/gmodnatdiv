class Studydesign < ActiveRecord::Base
    belongs_to :study, :class_name => 'Study', :foreign_key => :study_id
    has_many :studydesignprops , :foreign_key => :studydesign_id
    has_many :studyfactors , :foreign_key => :studydesign_id
    
end
