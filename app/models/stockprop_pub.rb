class StockpropPub < ActiveRecord::Base
    belongs_to :stockprop, :class_name => 'Stockprop', :foreign_key => :stockprop_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
