class Protocol < ActiveRecord::Base
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
    has_many :arraydesigns 
    has_many :arraydesigns , :foreign_key => :protocol_id
    has_many :dbxrefs 
    has_many :assays , :foreign_key => :protocol_id
    has_many :dbxrefs 
    has_many :assays 
    has_many :acquisitions , :foreign_key => :protocol_id
    has_many :channels 
    has_many :protocolparams , :foreign_key => :protocol_id
    has_many :quantifications , :foreign_key => :protocol_id
    has_many :acquisitions 
    has_many :treatments , :foreign_key => :protocol_id
    has_many :biomaterials 
    
end
