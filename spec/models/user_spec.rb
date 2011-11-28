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
    end

    before(:each) do
        valid_user_attrs =
        {
            :name => "user name",
            :surname => "user surname",
            :nickname => "user nickname",
            :email => "username@domain.com"
        }
        @user_attrs = valid_user_attrs
    end

    it "Should reject a blank name" do
        user = User.new(@user_attrs.merge(:name => ""))
        user.should_not be_valid
    end

    it "Should accept a blank surname" do
        user = User.new(@user_attrs.merge(:surname => ""))
        user.should be_valid
    end

    it "Should accept a blank nickname" do
        user = User.new(@user_attrs.merge(:nickname => ""))
        user.should be_valid
    end

    it "Should reject a name that is too long" do
        valid_name = "V" * @max_allowed_lenth_for_names
        invalid_name = "I" * (@max_allowed_lenth_for_names + 1)

        valid_user = User.new(@user_attrs.merge(:name => valid_name))
        valid_user.should be_valid, "A name of #{@max_allowed_lenth_for_names} characters should be accepted"

        invalid_user = User.new(@user_attrs.merge(:name => invalid_name))
        invalid_user.should_not be_valid, "A name of #{@max_allowed_lenth_for_names + 1} characters should be rejected"
    end

    it "Should reject a surname that is too long" do
        valid_surname = "V" * @max_allowed_lenth_for_names
        invalid_surname = "I" * (@max_allowed_lenth_for_names + 1)

        valid_user = User.new(@user_attrs.merge(:surname => valid_surname))
        valid_user.should be_valid, "A surname of #{@max_allowed_lenth_for_names} characters should be accepted"

        invalid_user = User.new(@user_attrs.merge(:surname => invalid_surname))
        invalid_user.should_not be_valid, "A surname of #{@max_allowed_lenth_for_names + 1} characters should be rejected"
    end

    it "Should reject a nickname that is too long" do
        valid_nickname = "V" * @max_allowed_lenth_for_names
        invalid_nickname = "I" * (@max_allowed_lenth_for_names + 1)

        valid_user = User.new(@user_attrs.merge(:nickname => valid_nickname))
        valid_user.should be_valid, "A nickname of #{@max_allowed_lenth_for_names} characters should be accepted"

        invalid_user = User.new(@user_attrs.merge(:nickname => invalid_nickname))
        invalid_user.should_not be_valid, "A nickname of #{@max_allowed_lenth_for_names + 1} characters should be rejected"
    end

    it "Should accept valid emails" do
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

    it "Should reject invalid emails" do
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

    it "Should have unique email" do
        same_email = "user@domain.com"

        first_user = User.new(:name => "First", :email => same_email)
        first_user.should be_valid
        first_user.save

        second_user = User.new(:name => "Second", :email => same_email)
        second_user.should_not be_valid
    end

    it "Should reject emails only differing by case" do
        same_email = "user@domain.com"

        first_user = User.new(:name => "First", :email => same_email.downcase)
        first_user.should be_valid
        first_user.save

        second_user = User.new(:name => "Second", :email => same_email.upcase)
        second_user.should_not be_valid
    end
end