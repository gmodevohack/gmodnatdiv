class CellLineprop < ActiveRecord::Base
    belongs_to :cell_line, :class_name => 'CellLine', :foreign_key => :cell_line_id
    has_many :cell_lineprop_pubs , :foreign_key => :cell_lineprop_id
    has_many :pubs 
    
end
