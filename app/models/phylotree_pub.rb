class PhylotreePub < ActiveRecord::Base
    belongs_to :phylotree, :class_name => 'Phylotree', :foreign_key => :phylotree_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
