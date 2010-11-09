class NdExperimentStockDbxref < ActiveRecord::Base

  belongs_to :nd_experiment_stock
  belongs_to :dbxref

  validates_presence_of(:nd_experiment_stock_id, :dbxref_id)
end
