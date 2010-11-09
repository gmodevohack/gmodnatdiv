class PhylonodeOrganism < ActiveRecord::Base
    belongs_to :phylonode, :class_name => 'Phylonode', :foreign_key => :phylonode_id
    belongs_to :organism, :class_name => 'Organism', :foreign_key => :organism_id
    
end
