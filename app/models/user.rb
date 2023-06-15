class User < ApplicationRecord

  belongs_to :region
  belongs_to :agency
  has_many :transactions



end

