class StockCvterm < ActiveRecord::Base
    belongs_to :stock, :class_name => 'Stock', :foreign_key => :stock_id
    belongs_to :cvterm, :class_name => 'Cvterm', :foreign_key => :cvterm_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
