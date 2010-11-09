class Quantification < ActiveRecord::Base
    belongs_to :acquisition, :class_name => 'Acquisition', :foreign_key => :acquisition_id
    belongs_to :protocol, :class_name => 'Protocol', :foreign_key => :protocol_id
    has_many :elementresults , :foreign_key => :quantification_id
    has_many :elements 
    has_many :quantificationprops , :foreign_key => :quantification_id
    
end
