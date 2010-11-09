class ExpressionImage < ActiveRecord::Base
    belongs_to :expression, :class_name => 'Expression', :foreign_key => :expression_id
    belongs_to :eimage, :class_name => 'Eimage', :foreign_key => :eimage_id
    
end
