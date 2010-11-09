class Control < ActiveRecord::Base
    belongs_to :assay, :class_name => 'Assay', :foreign_key => :assay_id
    belongs_to :tableinfo, :class_name => 'Tableinfo', :foreign_key => :tableinfo_id
    
end
