class Cv < ActiveRecord::Base

  set_table_name "cv"
  set_primary_key "cv_id"

  has_many :cvtermpaths , :foreign_key => :cv_id
  has_many :cvterms , :foreign_key => :cv_id
  has_many :dbxrefs 

  validates_presence_of( :name, :message => " can't be blank" )

end
