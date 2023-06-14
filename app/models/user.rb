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

  def total_transactions
    transactions.where("created_at >= ?", 1.days.ago).count
  end
end


