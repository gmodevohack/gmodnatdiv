class Expressionprop < ActiveRecord::Base
    belongs_to :expression, :class_name => 'Expression', :foreign_key => :expression_id
    
end
