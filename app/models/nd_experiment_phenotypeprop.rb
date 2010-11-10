class NdExperimentPhenotypeprop < ActiveRecord::Base

  belongs_to :nd_experiment_phenotype
  belongs_to :cvterm

  validates_presence_of( :nd_experiment_phenotype_id, :type_id )
end
