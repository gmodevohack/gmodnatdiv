class BiomaterialDbxref < ActiveRecord::Base
    belongs_to :biomaterial, :class_name => 'Biomaterial', :foreign_key => :biomaterial_id
    belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
    
end
