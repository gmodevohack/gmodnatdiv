class CellLineDbxref < ActiveRecord::Base
    belongs_to :cell_line, :class_name => 'CellLine', :foreign_key => :cell_line_id
    belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
    
end
