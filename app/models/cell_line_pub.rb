class CellLinePub < ActiveRecord::Base
    belongs_to :cell_line, :class_name => 'CellLine', :foreign_key => :cell_line_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
