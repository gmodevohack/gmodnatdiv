class StockRelationship < ActiveRecord::Base
  belongs_to :cvterm, :foreign_key => 'type_id'
  belongs_to :parent, :class_name => "Stock"
  belongs_to :child, :class_name => "Stock"
  
  validates_presence_of :subject_id, :object_id, :type_id
end
