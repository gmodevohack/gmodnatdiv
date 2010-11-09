class Biomaterialprop < ActiveRecord::Base
    belongs_to :biomaterial, :class_name => 'Biomaterial', :foreign_key => :biomaterial_id
    
end
