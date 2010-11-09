class Acquisition < ActiveRecord::Base
    belongs_to :assay, :class_name => 'Assay', :foreign_key => :assay_id
    belongs_to :protocol, :class_name => 'Protocol', :foreign_key => :protocol_id
    belongs_to :channel, :class_name => 'Channel', :foreign_key => :channel_id
    has_many :acquisitionprops , :foreign_key => :acquisition_id
    has_many :quantifications , :foreign_key => :acquisition_id
    has_many :protocols 
    
end
