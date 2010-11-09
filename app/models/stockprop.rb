class Stockprop < ActiveRecord::Base
  
  belongs_to :cvterm, :foreign_key=>'type_id'
  belongs_to :stock, :class_name => 'Stock', :foreign_key => :stock_id
  has_many :pubs 
  has_many :stockprop_pubs , :foreign_key => :stockprop_id

  validates_presence_of( :stock_id, :type_id )

end
