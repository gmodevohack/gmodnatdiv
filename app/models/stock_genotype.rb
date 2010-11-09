class StockGenotype < ActiveRecord::Base
    belongs_to :stock, :class_name => 'Stock', :foreign_key => :stock_id
    belongs_to :genotype, :class_name => 'Genotype', :foreign_key => :genotype_id

  validates_presence_of( :stock_id, :genotype_id)
end
