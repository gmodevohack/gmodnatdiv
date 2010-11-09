class CellLine < ActiveRecord::Base
    belongs_to :organism, :class_name => 'Organism', :foreign_key => :organism_id
    has_many :cell_line_libraries , :foreign_key => :cell_line_id
    has_many :pubs 
    has_many :cvterms 
    has_many :cell_line_dbxrefs , :foreign_key => :cell_line_id
    has_many :dbxrefs 
    has_many :cell_line_features , :foreign_key => :cell_line_id
    has_many :features 
    has_many :pubs 
    has_many :cell_line_cvterms , :foreign_key => :cell_line_id
    has_many :pubs 
    has_many :libraries 
    has_many :cell_line_pubs , :foreign_key => :cell_line_id
    has_many :pubs 
    has_many :cell_line_synonyms , :foreign_key => :cell_line_id
    has_many :synonyms 
    has_many :pubs 
    has_many :cell_lineprops , :foreign_key => :cell_line_id
    
end
