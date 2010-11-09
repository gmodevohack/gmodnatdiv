class NdExperimentStock < ActiveRecord::Base

  belongs_to :cvterm, :foreign_key => 'type_id'
  belongs_to :nd_experiment
  belongs_to :stock

  has_many :nd_experiment_stockprops
  has_many :nd_experiment_stock_dbxrefs

  validates_presence_of(:nd_experiment_id, :stock_id, :type_id)
end
