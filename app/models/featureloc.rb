class Featureloc < ActiveRecord::Base

  set_table_name "featureloc"
  set_primary_key "featureloc_id"

  belongs_to :feature, :class_name => 'Feature', :foreign_key => :feature_id
  has_many :featureloc_pubs , :foreign_key => :featureloc_id
  has_many :pubs 

  validates_presence_of( :feature_id )

end
