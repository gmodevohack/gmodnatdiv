class Projectprop < ActiveRecord::Base
  belongs_to :project
  belongs_to :cvterm

  validates_presence_of( :project_id, :cvterm_id )
end
