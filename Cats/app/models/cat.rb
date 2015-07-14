class Cat < ActiveRecord::Base
  COLOR = ["black", "white", "brown", "orange"]

  validates :birth_date, :name, presence: true
  validates :sex, inclusion: { in: %w(M F),
    message: "%{value} is not valid" }
  validates :color, inclusion: { in: COLOR,
    message: "%{value} is not a valid color" }


  has_many(
    :cat_rental_requests,
    :foreign_key => :cat_id,
    :primary_key => :id,
    :class_name => "CatRentalRequest",
    :dependent => :destroy
  )
end
