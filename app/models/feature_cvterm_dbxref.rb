class FeatureCvtermDbxref < ActiveRecord::Base
    belongs_to :feature_cvterm, :class_name => 'FeatureCvterm', :foreign_key => :feature_cvterm_id
    belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
    
end
