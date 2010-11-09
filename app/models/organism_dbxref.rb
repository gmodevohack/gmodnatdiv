class OrganismDbxref < ActiveRecord::Base
    belongs_to :organism, :class_name => 'Organism', :foreign_key => :organism_id
    belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
    
end
