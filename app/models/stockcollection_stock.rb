class StockcollectionStock < ActiveRecord::Base
    belongs_to :stockcollection, :class_name => 'Stockcollection', :foreign_key => :stockcollection_id
    belongs_to :stock, :class_name => 'Stock', :foreign_key => :stock_id
    
end
