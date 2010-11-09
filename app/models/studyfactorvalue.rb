class Studyfactorvalue < ActiveRecord::Base
    belongs_to :studyfactor, :class_name => 'Studyfactor', :foreign_key => :studyfactor_id
    belongs_to :assay, :class_name => 'Assay', :foreign_key => :assay_id
    
end
