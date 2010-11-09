class Phylonodeprop < ActiveRecord::Base
    belongs_to :phylonode, :class_name => 'Phylonode', :foreign_key => :phylonode_id
    
end
