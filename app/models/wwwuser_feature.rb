class WwwuserFeature < ActiveRecord::Base

  belongs_to :wwwuser
  belongs_to :feature

  validates_presence_of( :wwwuser_id, :message => "must be associated with a wwwuser")
  validates_presence_of( :feature_id, :message => "must be associated with a feature")

  validates_uniqueness_of( :wwwuser_id, :scope => [:feature_id], :message => "seems to already be an entry for this wwwuser + feature" )

  set_table_name "wwwuser_feature"
  set_primary_key "wwwuser_feature_id"

end
