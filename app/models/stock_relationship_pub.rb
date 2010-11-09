class StockRelationshipPub < ActiveRecord::Base
    belongs_to :stock_relationship, :class_name => 'StockRelationship', :foreign_key => :stock_relationship_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
