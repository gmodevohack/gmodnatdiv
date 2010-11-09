class Protocolparam < ActiveRecord::Base
    belongs_to :protocol, :class_name => 'Protocol', :foreign_key => :protocol_id
    
end
