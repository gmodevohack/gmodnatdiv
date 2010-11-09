class PhylonodePub < ActiveRecord::Base
    belongs_to :phylonode, :class_name => 'Phylonode', :foreign_key => :phylonode_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
