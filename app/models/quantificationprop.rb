class Quantificationprop < ActiveRecord::Base
    belongs_to :quantification, :class_name => 'Quantification', :foreign_key => :quantification_id
    
end
