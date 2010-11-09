class Library < ActiveRecord::Base
    belongs_to :organism, :class_name => 'Organism', :foreign_key => :organism_id
    has_many :dbxrefs 
    has_many :cell_lines 
    has_many :cell_line_libraries , :foreign_key => :library_id
    has_many :library_cvterms , :foreign_key => :library_id
    has_many :pubs 
    has_many :cvterms 
    has_many :library_dbxrefs , :foreign_key => :library_id
    has_many :pubs 
    has_many :library_features , :foreign_key => :library_id
    has_many :features 
    has_many :library_pubs , :foreign_key => :library_id
    has_many :pubs 
    has_many :library_synonyms , :foreign_key => :library_id
    has_many :synonyms 
    has_many :pubs 
    has_many :libraryprops , :foreign_key => :library_id
    
end
