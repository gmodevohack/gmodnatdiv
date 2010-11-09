class Db < ActiveRecord::Base
  has_many :dbxrefs

  validates_presence_of( :name )
end
