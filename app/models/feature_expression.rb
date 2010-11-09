class FeatureExpression < ActiveRecord::Base
    belongs_to :expression, :class_name => 'Expression', :foreign_key => :expression_id
    belongs_to :feature, :class_name => 'Feature', :foreign_key => :feature_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    has_many :feature_expressionprops , :foreign_key => :feature_expression_id
    
end
