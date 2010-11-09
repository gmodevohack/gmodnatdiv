class Arraydesignprop < ActiveRecord::Base
    belongs_to :arraydesign, :class_name => 'Arraydesign', :foreign_key => :arraydesign_id
    
end
