class Stockcollectionprop < ActiveRecord::Base
    belongs_to :stockcollection, :class_name => 'Stockcollection', :foreign_key => :stockcollection_id
    
end
