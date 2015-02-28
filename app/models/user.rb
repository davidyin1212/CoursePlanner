class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_and_belongs_to_many :courses
	has_and_belongs_to_many :degrees
	has_many :comments
	# has_secure_password

	validates :password,	length: { minimum: 8 }
	validates :email, 	presence: true

end
