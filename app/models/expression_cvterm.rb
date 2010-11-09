class ExpressionCvterm < ActiveRecord::Base
    belongs_to :expression, :class_name => 'Expression', :foreign_key => :expression_id
    belongs_to :cvterm, :class_name => 'Cvterm', :foreign_key => :cvterm_id
    has_many :expression_cvtermprops , :foreign_key => :expression_cvterm_id
    
end
