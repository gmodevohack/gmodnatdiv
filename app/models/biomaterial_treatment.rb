class BiomaterialTreatment < ActiveRecord::Base
    belongs_to :biomaterial, :class_name => 'Biomaterial', :foreign_key => :biomaterial_id
    belongs_to :treatment, :class_name => 'Treatment', :foreign_key => :treatment_id
    
end
