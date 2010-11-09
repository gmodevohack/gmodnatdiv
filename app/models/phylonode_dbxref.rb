class PhylonodeDbxref < ActiveRecord::Base
    belongs_to :phylonode, :class_name => 'Phylonode', :foreign_key => :phylonode_id
    belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
    
end
