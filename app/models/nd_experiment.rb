class NdExperiment < ActiveRecord::Base
  belongs_to :cvterm, :foreign_key => 'type_id'

  belongs_to :nd_geolocation

  has_many :nd_experimentprops
  has_many :nd_experiment_dbxrefs
  has_many :nd_experiment_genotypes
  has_many :nd_experiment_phenotypes
  has_many :nd_experiment_projects
  has_many :nd_experiment_protocols
  has_many :nd_experiment_stocks

  validates_presence_of(:nd_geolocation_id, :type_id)
end
