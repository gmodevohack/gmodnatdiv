class ExpressionCvtermprop < ActiveRecord::Base
    belongs_to :expression_cvterm, :class_name => 'ExpressionCvterm', :foreign_key => :expression_cvterm_id
    
end
