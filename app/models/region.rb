class Region < ApplicationRecord
  has_many :users
  has_many :agency

  def total_agencies
    agencies.count
  end
end
