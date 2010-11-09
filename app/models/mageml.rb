class Mageml < ActiveRecord::Base
    has_many :magedocumentations , :foreign_key => :mageml_id
    has_many :tableinfos 
    
end
