class NdProtocol < ActiveRecord::Base

  has_many :nd_experiment_protocols
  has_many :nd_protocol_reagents
  has_many :nd_protocolprops

  validates_presence_of :name
end
