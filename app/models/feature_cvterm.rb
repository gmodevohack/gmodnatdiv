class FeatureCvterm < ActiveRecord::Base
    belongs_to :feature, :class_name => 'Feature', :foreign_key => :feature_id
    belongs_to :cvterm, :class_name => 'Cvterm', :foreign_key => :cvterm_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    has_many :dbxrefs 
    has_many :feature_cvterm_dbxrefs , :foreign_key => :feature_cvterm_id
    has_many :feature_cvterm_pubs , :foreign_key => :feature_cvterm_id
    has_many :pubs 
    has_many :feature_cvtermprops , :foreign_key => :feature_cvterm_id
    
end
