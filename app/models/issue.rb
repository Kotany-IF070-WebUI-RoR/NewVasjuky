class Issue < ApplicationRecord
  REGEXP_NAME = /\A['a-z \.-]+\z/i
  REGEXP_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.\w+\z/i
  REGEXP_PHONE = /\A[ x0-9\+\(\)\-\.]+\z/
  validates :name, :address, :phone, :email, :category, :description,
            presence: true
  validates :name, length: { maximum: 50 },
                   format: { with: REGEXP_NAME,
                             message: 'should contain only letters' }
  validates :phone, length: { maximum: 50 },
                    format: { with: REGEXP_PHONE,
                              message: 'should contain only numbers' }
  validates :email, length: { maximum: 255 },
                    format: { with: REGEXP_EMAIL,
                              message: 'should be valid' }
  validates :description, length: { minimum: 50 }
end
