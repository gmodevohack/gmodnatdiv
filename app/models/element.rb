class Element < ActiveRecord::Base
    belongs_to :feature, :class_name => 'Feature', :foreign_key => :feature_id
    belongs_to :arraydesign, :class_name => 'Arraydesign', :foreign_key => :arraydesign_id
    belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
    has_many :elementresults , :foreign_key => :element_id
    has_many :quantifications 
    
end
