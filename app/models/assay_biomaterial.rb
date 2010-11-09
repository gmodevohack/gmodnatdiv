class AssayBiomaterial < ActiveRecord::Base
    belongs_to :assay, :class_name => 'Assay', :foreign_key => :assay_id
    belongs_to :biomaterial, :class_name => 'Biomaterial', :foreign_key => :biomaterial_id
    belongs_to :channel, :class_name => 'Channel', :foreign_key => :channel_id
    
end
