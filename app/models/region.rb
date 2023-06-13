class Region < ApplicationRecord
  has_many :users
  has_many :agencies

  def total_users
    users.count
  end

  def total_agencies
    agencies.count
  end
end






