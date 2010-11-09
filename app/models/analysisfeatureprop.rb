class Analysisfeatureprop < ActiveRecord::Base
    belongs_to :analysisfeature, :class_name => 'Analysisfeature', :foreign_key => :analysisfeature_id
    
end
