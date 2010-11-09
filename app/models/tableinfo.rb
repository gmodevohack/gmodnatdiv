class Tableinfo < ActiveRecord::Base
    has_many :controls , :foreign_key => :tableinfo_id
    has_many :assays 
    has_many :magedocumentations , :foreign_key => :tableinfo_id
    has_many :magemls 

  after_save :update_modification_date

  validates_presence_of( :name )

  set_table_name "tableinfo"
  set_primary_key "tableinfo_id"

  def update_modification_date 
    self.modification_date = Time.now
  end 

end
