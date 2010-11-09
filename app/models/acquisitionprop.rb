class Acquisitionprop < ActiveRecord::Base
    belongs_to :acquisition, :class_name => 'Acquisition', :foreign_key => :acquisition_id
    
end
