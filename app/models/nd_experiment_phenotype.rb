class NdExperimentPhenotype < ActiveRecord::Base

  belongs_to :nd_experiment
  belongs_to :phenotype

  validates_presence_of( :nd_experiment_id, :phenotype_id )
end
