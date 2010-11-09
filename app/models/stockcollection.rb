class Stockcollection < ActiveRecord::Base
    belongs_to :contact, :class_name => 'Contact', :foreign_key => :contact_id
    has_many :stocks 
    has_many :stockcollection_stocks , :foreign_key => :stockcollection_id
    has_many :stockcollectionprops , :foreign_key => :stockcollection_id
    
end
