class Transaction < ApplicationRecord
  belongs_to :user

  def user_name
    user.name if user
  end
end
