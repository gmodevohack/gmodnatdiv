class Studyfactor < ActiveRecord::Base
    belongs_to :studydesign, :class_name => 'Studydesign', :foreign_key => :studydesign_id
    has_many :studyfactorvalues , :foreign_key => :studyfactor_id
    has_many :assays 
    
end
