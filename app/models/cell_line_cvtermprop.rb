class CellLineCvtermprop < ActiveRecord::Base
    belongs_to :cell_line_cvterm, :class_name => 'CellLineCvterm', :foreign_key => :cell_line_cvterm_id
    
end
