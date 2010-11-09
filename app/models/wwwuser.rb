class Wwwuser < ActiveRecord::Base

  has_many :wwwuser_cvterms
  has_many :wwwuser_expressions
  has_many :wwwuser_features
  has_many :wwwuser_phenotypes
  has_many :wwwuser_projects
  has_many :wwwuser_pubs

  validates_presence_of( :username, :password, :email )
  validates_uniqueness_of( :username )

  set_table_name "wwwuser"
  set_primary_key "wwwuser_id"

end
