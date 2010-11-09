class Channel < ActiveRecord::Base
    has_many :acquisitions , :foreign_key => :channel_id
    has_many :assays 
    has_many :protocols 
    has_many :assay_biomaterials , :foreign_key => :channel_id
    has_many :biomaterials 
    has_many :assays 
    
end
