class Eimage < ActiveRecord::Base
    has_many :expression_images , :foreign_key => :eimage_id
    has_many :expressions 
    
end
