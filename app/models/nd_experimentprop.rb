class NdExperimentprop < ActiveRecord::Base

  belongs_to :nd_experiment
  belongs_to :cvterm

  validates_presence_of( :nd_experiment_id, :cvterm_id )
end
