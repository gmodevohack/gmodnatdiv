class Featureprop < ActiveRecord::Base
 
  set_table_name "featureprop"
  set_primary_key "featureprop_id"

  belongs_to :cvterm, :foreign_key => "type_id"
  belongs_to :feature, :class_name => 'Feature', :foreign_key => :feature_id
  has_many :featureprop_pubs , :foreign_key => :featureprop_id
  has_many :pubs 

  validates_presence_of( :feature_id, :type_id )
  
end
