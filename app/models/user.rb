class User < ActiveRecord::Base
	has_and_belongs_to_many :courses
	has_and_belongs_to_many :degrees
	has_many :comments
	has_secure_password

	validates :password,	length: { minimum: 8 }
	validates :email, 	presence: true

end
