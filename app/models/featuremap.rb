class Featuremap < ActiveRecord::Base
    has_many :featuremap_pubs , :foreign_key => :featuremap_id
    has_many :pubs 
    has_many :featurepos , :foreign_key => :featuremap_id
    has_many :features 
    has_many :featureranges , :foreign_key => :featuremap_id
    has_many :features 
    
end
