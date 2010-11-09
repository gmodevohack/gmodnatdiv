class Contactprop < ActiveRecord::Base
  belongs_to :contact
  belongs_to :cvterm, :foreign_key => "type_id"

  validates_presence_of :contact_id, :type_id
end
