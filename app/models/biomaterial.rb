class Biomaterial < ActiveRecord::Base
    belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
    has_many :dbxrefs 
    has_many :assays 
    has_many :assay_biomaterials , :foreign_key => :biomaterial_id
    has_many :biomaterial_dbxrefs , :foreign_key => :biomaterial_id
    has_many :channels 
    has_many :biomaterial_treatments , :foreign_key => :biomaterial_id
    has_many :treatments 
    has_many :biomaterialprops , :foreign_key => :biomaterial_id
    has_many :treatments , :foreign_key => :biomaterial_id
    has_many :protocols 
    
end
