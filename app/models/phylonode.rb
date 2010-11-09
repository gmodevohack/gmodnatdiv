class Phylonode < ActiveRecord::Base
    belongs_to :phylotree, :class_name => 'Phylotree', :foreign_key => :phylotree_id
    belongs_to :feature, :class_name => 'Feature', :foreign_key => :feature_id
    has_many :dbxrefs 
    has_many :phylonode_dbxrefs , :foreign_key => :phylonode_id
    has_many :pubs 
    has_many :organisms 
    has_many :phylonode_pubs , :foreign_key => :phylonode_id
    has_many :phylonodeprops , :foreign_key => :phylonode_id
    has_one :phylonode_organism , :foreign_key => :phylonode_id
    
end
