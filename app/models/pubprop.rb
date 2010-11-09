class Pubprop < ActiveRecord::Base
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
