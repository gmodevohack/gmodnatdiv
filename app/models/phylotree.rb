class Phylotree < ActiveRecord::Base
    belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
    has_many :phylonodes , :foreign_key => :phylotree_id
    has_many :phylonode_relationships , :foreign_key => :phylotree_id
    has_many :features 
    has_many :phylotree_pubs , :foreign_key => :phylotree_id
    has_many :pubs 
    
end
