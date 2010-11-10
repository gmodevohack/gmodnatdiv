class NdExperimentStockprop < ActiveRecord::Base

  belongs_to :nd_experiment_stock
  belongs_to :cvterm

  validates_presence_of( :nd_experiment_stock_id, :type_id )
end
