# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  surname            :string(255)
#  nickname           :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

require 'digest'

EMAIL_VALIDATION_TEMPLATE = /^[\w.+-]+@[a-z\d.-]+\.[a-z]{2,4}$/i
MAXIMUM_LENGTH_FOR_NAMES = 64
MINIMUM_LENGTH_FOR_PASSWORD = 8
MAXIMUM_LENGTH_FOR_PASSWORD = 255

class User < ActiveRecord::Base
    attr_accessor :password
    attr_accessible :name,
                    :surname,
                    :nickname,
                    :email,
                    :password,
                    :password_confirmation

    validates :name, :presence => true,
                     :length =>  { :maximum => MAXIMUM_LENGTH_FOR_NAMES }

    validates :surname, :length =>  { :maximum => MAXIMUM_LENGTH_FOR_NAMES }

    validates :nickname, :length =>  { :maximum => MAXIMUM_LENGTH_FOR_NAMES }

    validates :email, :presence => true,
                      :format => { :with => EMAIL_VALIDATION_TEMPLATE },
                      :uniqueness => { :case_sensitive => false }

    validates :password, :presence => true,
                         :confirmation => true,
                         :length =>  { :within =>
                            MINIMUM_LENGTH_FOR_PASSWORD..MAXIMUM_LENGTH_FOR_PASSWORD}

    before_save :encrypt_password

    def self.authenticate(email, password)
        user = find_by_email(email)
        (user && user.has_password?(password)) ? user : nil
    end

    def self.authenticate_with_remember_token(id, salt)
        user = User.find_by_id(id)
        (user && user.salt == salt) ? user : nil
    end

    # Checks if the submitted password matches the stored password.
    def has_password?(submitted_password)
        encrypted_password == encrypt(submitted_password)
    end

    def full_name
        return "#{nickname} (#{personal_name})" unless nickname.blank?
        personal_name
    end

    def short_name
        return nickname unless nickname.blank?
        personal_name
    end

    private
        def encrypt_password
            self.salt = make_salt unless has_password?(password)
            self.encrypted_password = encrypt(password)
        end

        def make_salt
            secure_hash("#{Time.now.utc}--#{password}")
        end

        def encrypt(text)
            secure_hash("#{salt}--#{text}")
        end

        def secure_hash(text)
            Digest::SHA2.hexdigest(text)
        end

        def personal_name
            name + ((surname.blank?) ? "" : " #{surname}")
        end
end
