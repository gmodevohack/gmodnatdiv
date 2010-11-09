class NdExperimentProject < ActiveRecord::Base

  belongs_to :nd_experiment
  belongs_to :project

  validates_presence_of(:nd_experiment_id, :project_id)
end
