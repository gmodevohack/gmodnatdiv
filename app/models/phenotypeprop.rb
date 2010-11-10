class Phenotypeprop < ActiveRecord::Base
  belongs_to :phenotype
  belongs_to :cvterm

  validates_presence_of( :phenotype_id, :type_id )
end
