class ExpressionPub < ActiveRecord::Base
    belongs_to :expression, :class_name => 'Expression', :foreign_key => :expression_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
