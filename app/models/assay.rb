class Assay < ActiveRecord::Base
    belongs_to :arraydesign, :class_name => 'Arraydesign', :foreign_key => :arraydesign_id
    belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
    belongs_to :protocol, :class_name => 'Protocol', :foreign_key => :protocol_id
    has_many :assay_projects , :foreign_key => :assay_id
    has_many :protocols 
    has_many :channels 
    has_many :assay_biomaterials , :foreign_key => :assay_id
    has_many :biomaterials 
    has_many :channels 
    has_many :acquisitions , :foreign_key => :assay_id
    has_many :projects 
    has_many :assayprops , :foreign_key => :assay_id
    has_many :controls , :foreign_key => :assay_id
    has_many :tableinfos 
    has_many :phenotypes , :foreign_key => :assay_id
    has_many :study_assays , :foreign_key => :assay_id
    has_many :studies 
    has_many :studyfactorvalues , :foreign_key => :assay_id
    has_many :studyfactors 
    
end
