class WwwuserExpression < ActiveRecord::Base

  belongs_to :wwwuser
  belongs_to :expression

  validates_presence_of( :wwwuser_id, :message => "must be associated with a wwwuser")
  validates_presence_of( :expression_id, :message => "must be associated with an expression object")

  validates_uniqueness_of( :wwwuser_id, :scope => [:expression_id], :message => "seems to already be an entry for this wwwuser + cvterm" )


  set_table_name "wwwuser_expression"
  set_primary_key "wwwuser_expression_id"

end
