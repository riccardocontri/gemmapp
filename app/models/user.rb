# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  surname    :string(255)
#  nickname   :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

EMAIL_VALIDATION_TEMPLATE = /^[\w.+-]+@[a-z\d.-]+\.[a-z]{2,4}$/i
MAXIMUM_LENGTH_FOR_NAMES = 64

class User < ActiveRecord::Base
    attr_accessible :name, :surname, :nickname, :email

    validates :name, :presence => true,
                     :length =>  { :maximum => MAXIMUM_LENGTH_FOR_NAMES }

    validates :surname, :length =>  { :maximum => MAXIMUM_LENGTH_FOR_NAMES }

    validates :nickname, :length =>  { :maximum => MAXIMUM_LENGTH_FOR_NAMES }

    validates :email, :presence => true,
                      :format => { :with => EMAIL_VALIDATION_TEMPLATE },
                      :uniqueness => { :case_sensitive => false }
end
