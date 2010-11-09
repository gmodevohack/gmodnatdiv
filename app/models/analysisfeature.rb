class Analysisfeature < ActiveRecord::Base
    belongs_to :feature, :class_name => 'Feature', :foreign_key => :feature_id
    has_many :analysisfeatureprops , :foreign_key => :analysisfeature_id
    
end
