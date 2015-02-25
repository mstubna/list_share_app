class List < ActiveRecord::Base
  belongs_to :user

  has_many :collaborations

  has_many(
    :collaborators,
    through: :collaborations,
    source: :user,
    class_name: User.name,
    foreign_key: 'user_id',
    dependent: :destroy
  )

  validates(
    :user,
    presence: true
  )
end
