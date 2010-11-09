class StockPub < ActiveRecord::Base
    belongs_to :stock, :class_name => 'Stock', :foreign_key => :stock_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
