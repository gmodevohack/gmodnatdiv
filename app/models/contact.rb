class Contact < ActiveRecord::Base
    has_many :stockcollections , :foreign_key => :contact_id
    has_many :studies , :foreign_key => :contact_id
    has_many :dbxrefs 
    has_many :pubs 

  has_many :contactprops

  validates_presence_of :name
end
