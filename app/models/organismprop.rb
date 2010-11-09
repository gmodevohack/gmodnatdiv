class Organismprop < ActiveRecord::Base
    belongs_to :organism, :class_name => 'Organism', :foreign_key => :organism_id
    
end
