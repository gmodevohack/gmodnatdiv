class FeatureDbxref < ActiveRecord::Base
    belongs_to :feature, :class_name => 'Feature', :foreign_key => :feature_id
    belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
    
end
