class WwwuserCvterm < ActiveRecord::Base

  belongs_to :wwwuser
  belongs_to :cvterm

  validates_presence_of( :wwwuser_id, :message => "must be associated with a wwwuser")
  validates_presence_of( :cvterm_id, :message => "must be associated with a cvterm")

  validates_uniqueness_of( :cvterm_id, :scope => [:wwwuser_id], :message => "seems to already be an entry for this wwwuser + cvterm" )

  set_table_name "wwwuser_cvterm"
  set_primary_key "wwwuser_cvterm_id"

end
