class NdExperimentProtocol < ActiveRecord::Base

  belongs_to :nd_experiment
  belongs_to :nd_protocol

  validates_presence_of(:nd_experiment_id, :nd_protocol_id)
end
