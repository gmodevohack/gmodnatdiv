class Arraydesign < ActiveRecord::Base
    belongs_to :protocol, :class_name => 'Protocol', :foreign_key => :protocol_id
    belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
    has_many :dbxrefs 
    has_many :assays , :foreign_key => :arraydesign_id
    has_many :arraydesignprops , :foreign_key => :arraydesign_id
    has_many :protocols 
    has_many :elements , :foreign_key => :arraydesign_id
    has_many :dbxrefs 
    has_many :features 
    
end
