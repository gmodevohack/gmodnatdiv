class Synonym < ActiveRecord::Base

  set_table_name "synonym"
  set_primary_key "synonym_id"

  has_and_belongs_to_many :features, :join_table => :feature_synonym
  has_many :cell_line_synonyms , :foreign_key => :synonym_id
  has_many :feature_synonyms , :foreign_key => :synonym_id
  has_many :features 
  has_many :libraries 
  has_many :library_synonyms , :foreign_key => :synonym_id
  has_many :pubs 

end
