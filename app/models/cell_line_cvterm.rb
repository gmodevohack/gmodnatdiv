class CellLineCvterm < ActiveRecord::Base
    belongs_to :cell_line, :class_name => 'CellLine', :foreign_key => :cell_line_id
    belongs_to :cvterm, :class_name => 'Cvterm', :foreign_key => :cvterm_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    has_many :cell_line_cvtermprops , :foreign_key => :cell_line_cvterm_id
    
end
