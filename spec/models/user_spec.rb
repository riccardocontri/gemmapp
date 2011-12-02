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

require 'spec_helper'

describe User do
    before(:all) do
        @max_allowed_lenth_for_names = 64
        @min_allowed_lenth_for_passwords = 8
        @max_allowed_lenth_for_passwords = 255
        @valid_password = '123Password'
    end

    before(:each) do
        valid_user_attrs =
        {
            :name => "user name",
            :surname => "user surname",
            :nickname => "user nickname",
            :email => "username@domain.com",
            :password => @valid_password,
            :password_confirmation => @valid_password
        }
        @user_attrs = valid_user_attrs
    end

    it "should reject a blank name" do
        user = User.new(@user_attrs.merge(:name => ""))
        user.should_not be_valid
    end

    it "should accept a blank surname" do
        user = User.new(@user_attrs.merge(:surname => ""))
        user.should be_valid
    end

    it "should accept a blank nickname" do
        user = User.new(@user_attrs.merge(:nickname => ""))
        user.should be_valid
    end

    it "should reject a name that is too long" do
        valid_name = "V" * @max_allowed_lenth_for_names
        invalid_name = "I" * (@max_allowed_lenth_for_names + 1)

        valid_user = User.new(@user_attrs.merge(:name => valid_name))
        valid_user.should be_valid, "A name of #{valid_name.length} characters should be accepted"

        invalid_user = User.new(@user_attrs.merge(:name => invalid_name))
        invalid_user.should_not be_valid, "A name of #{invalid_name.length} characters should be rejected"
    end

    it "should reject a surname that is too long" do
        valid_surname = "V" * @max_allowed_lenth_for_names
        invalid_surname = "I" * (@max_allowed_lenth_for_names + 1)

        valid_user = User.new(@user_attrs.merge(:surname => valid_surname))
        valid_user.should be_valid, "A surname of #{valid_surname.length} characters should be accepted"

        invalid_user = User.new(@user_attrs.merge(:surname => invalid_surname))
        invalid_user.should_not be_valid, "A surname of #{invalid_surname.length} characters should be rejected"
    end

    it "should reject a nickname that is too long" do
        valid_nickname = "V" * @max_allowed_lenth_for_names
        invalid_nickname = "I" * (@max_allowed_lenth_for_names + 1)

        valid_user = User.new(@user_attrs.merge(:nickname => valid_nickname))
        valid_user.should be_valid, "A nickname of #{valid_nickname.length} characters should be accepted"

        invalid_user = User.new(@user_attrs.merge(:nickname => invalid_nickname))
        invalid_user.should_not be_valid, "A nickname of #{invalid_nickname.length} characters should be rejected"
    end

    it "should reject a blank password" do
        attrs = @user_attrs.merge(:password => "", :password_confirmation => "")
        user = User.new(attrs)
        user.should_not be_valid
    end

    it "should require a matching password confirmation" do
        attrs = @user_attrs.merge(:password => "123ABCdef", :password_confirmation => "fedCBA321")
        user = User.new(attrs)
        user.should_not be_valid
    end

    it "should reject a password that is too short" do
        valid_password = @valid_password[0, @min_allowed_lenth_for_passwords]
        invalid_password = valid_password.chop

        valid_attrs = @user_attrs.merge(
            :password => valid_password,
            :password_confirmation => valid_password)
        valid_user = User.new(valid_attrs)
        valid_user.should be_valid,
            "A password of #{valid_password.length} characters should be accepted"

        invalid_attrs = @user_attrs.merge(
            :password => invalid_password,
            :password_confirmation => invalid_password)
        invalid_user = User.new(invalid_attrs)
        invalid_user.should_not be_valid,
            "A password of #{invalid_password.length} characters should be rejected"
    end

    it "should reject a password that is too long" do
        valid_password = (@valid_password * 40)[0, @max_allowed_lenth_for_passwords]
        invalid_password = valid_password + '+'

        valid_attrs = @user_attrs.merge(
            :password => valid_password,
            :password_confirmation => valid_password)
        valid_user = User.new(valid_attrs)
        valid_user.should be_valid,
            "A password of #{valid_password.length} characters should be accepted"

        invalid_attrs = @user_attrs.merge(
            :password => invalid_password,
            :password_confirmation => invalid_password)
        invalid_user = User.new(invalid_attrs)
        invalid_user.should_not be_valid,
            "A password of #{invalid_password.length} characters should be rejected"
    end

    describe "password persistence" do
        before(:each) do
            @user = User.create!(@user_attrs)
        end

        it "should save an encrypted password" do
            @user.encrypted_password.should_not be_blank
        end

        describe "password checking" do
            it "should be true if submitted password matches stored one" do
                @user.has_password?(@user_attrs[:password]).should be_true
            end

            it "should be false if submitted password doesn't match stored one" do
                @user.has_password?(@user_attrs[:password].reverse).should be_false
            end
        end
    end

    it "should accept valid emails" do
        valid_emails =
        [
            "username@domain.org",
            "user.name@domain.org",
            "user_name@domain.org",
            "user-name@domain.org",
            "username@another-domain.org",
            "username@domain.co.uk"
        ]
        valid_emails.each do |valid_email|
            user = User.new(@user_attrs.merge(:email => valid_email))
            user.should be_valid, "email '#{valid_email}' should be accepted"
        end
    end

    it "should reject invalid emails" do
        invalid_emails =
        [
            "",
            "username@domain",
            "user/name@domain.org",
            "user@name@domain.org",
            "username@domain_org",
            "usernameATdomain.org"
        ]
        invalid_emails.each do |invalid_email|
            user = User.new(@user_attrs.merge(:email => invalid_email))
            user.should_not be_valid, "email '#{invalid_email}' should NOT be accepted"
        end
    end

    it "should have unique email" do
        same_email = "user@domain.com"

        first_user = User.new(@user_attrs.merge(:name => "First", :email => same_email))
        first_user.should be_valid
        first_user.save

        second_user = User.new(@user_attrs.merge(:name => "Second", :email => same_email))
        second_user.should_not be_valid
    end

    it "should reject emails only differing by case" do
        same_email = "user@domain.com"

        first_user = User.new(@user_attrs.merge(:name => "First", :email => same_email.downcase))
        first_user.should be_valid
        first_user.save

        second_user = User.new(@user_attrs.merge(:name => "Second", :email => same_email.upcase))
        second_user.should_not be_valid
    end
end