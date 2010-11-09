class Treatment < ActiveRecord::Base
    belongs_to :protocol, :class_name => 'Protocol', :foreign_key => :protocol_id
    belongs_to :biomaterial, :class_name => 'Biomaterial', :foreign_key => :biomaterial_id
    has_many :biomaterials 
    has_many :biomaterial_treatments , :foreign_key => :treatment_id
    
end
