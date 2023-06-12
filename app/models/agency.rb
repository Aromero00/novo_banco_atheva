class Agency < ApplicationRecord
  belongs_to :region
  has_many :users

  def total_users
    users.count
  end
  def region_name
    region.name if region
  end
end
