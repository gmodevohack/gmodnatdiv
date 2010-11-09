class Elementresult < ActiveRecord::Base
    belongs_to :element, :class_name => 'Element', :foreign_key => :element_id
    belongs_to :quantification, :class_name => 'Quantification', :foreign_key => :quantification_id
    
end
