class CellLinepropPub < ActiveRecord::Base
    belongs_to :cell_lineprop, :class_name => 'CellLineprop', :foreign_key => :cell_lineprop_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
