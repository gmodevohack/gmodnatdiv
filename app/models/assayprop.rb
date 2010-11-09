class Assayprop < ActiveRecord::Base
    belongs_to :assay, :class_name => 'Assay', :foreign_key => :assay_id
    
end
