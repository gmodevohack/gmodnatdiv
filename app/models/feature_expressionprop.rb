class FeatureExpressionprop < ActiveRecord::Base
    belongs_to :feature_expression, :class_name => 'FeatureExpression', :foreign_key => :feature_expression_id
    
end
