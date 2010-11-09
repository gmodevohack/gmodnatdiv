class StockDbxref < ActiveRecord::Base
    belongs_to :stock, :class_name => 'Stock', :foreign_key => :stock_id
    belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
    
end
