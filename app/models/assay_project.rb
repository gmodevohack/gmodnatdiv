class AssayProject < ActiveRecord::Base
    belongs_to :assay, :class_name => 'Assay', :foreign_key => :assay_id
    belongs_to :project, :class_name => 'Project', :foreign_key => :project_id
    
end
