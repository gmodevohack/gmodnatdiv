class PhylonodeRelationship < ActiveRecord::Base
    belongs_to :phylotree, :class_name => 'Phylotree', :foreign_key => :phylotree_id
    
end
