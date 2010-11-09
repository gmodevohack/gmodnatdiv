class NdExperimentDbxref < ActiveRecord::Base

  belongs_to :nd_experiment
  belongs_to :dbxref

  validates_presence_of( :nd_experiment_id, :dbxref_id )
end
