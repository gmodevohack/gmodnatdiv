class WwwuserPub < ActiveRecord::Base

  belongs_to :pub
  belongs_to :wwwuser

  validates_presence_of( :wwwuser_id, :pub_id )
  validates_uniqueness_of( :wwwuser_id, :scope => [:pub_id], :message => "seems to already be an entry for this wwwuser + pub" )

  set_table_name :wwwuser_pub
  set_primary_key :wwwuser_pub_id

end
