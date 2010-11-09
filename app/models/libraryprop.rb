class Libraryprop < ActiveRecord::Base
    belongs_to :library, :class_name => 'Library', :foreign_key => :library_id
    has_many :libraryprop_pubs , :foreign_key => :libraryprop_id
    has_many :pubs 
    
end
