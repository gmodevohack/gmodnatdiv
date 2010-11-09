class Studydesignprop < ActiveRecord::Base
    belongs_to :studydesign, :class_name => 'Studydesign', :foreign_key => :studydesign_id
    
end
