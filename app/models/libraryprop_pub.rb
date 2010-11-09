class LibrarypropPub < ActiveRecord::Base
    belongs_to :libraryprop, :class_name => 'Libraryprop', :foreign_key => :libraryprop_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
