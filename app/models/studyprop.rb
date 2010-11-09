class Studyprop < ActiveRecord::Base
    belongs_to :study, :class_name => 'Study', :foreign_key => :study_id
    has_many :studyprop_features , :foreign_key => :studyprop_id
    has_many :features 
    
end
