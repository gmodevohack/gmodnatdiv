class Genotype < ActiveRecord::Base
  validates_presence_of( :uniquename )

  has_many :nd_assay_genotypes
  has_many :wwwuser_genotypes
end
