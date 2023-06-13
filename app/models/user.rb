class User < ApplicationRecord

  belongs_to :region
  belongs_to :agency
  has_many :transactions

  def region_name
    region.name if region
  end

  def agency_name
     agency.name if agency
  end
end


