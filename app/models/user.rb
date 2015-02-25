class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many(
    :lists,
    dependent: :destroy
  )

  has_many :collaborations

  has_many(
    :shared_lists,
    through: :collaborations,
    source: :list,
    class_name: List.name,
    foreign_key: 'list_id',
    dependent: :destroy
  )

  def all_lists
    lists.to_ary.concat(shared_lists.to_ary)
  end
end
