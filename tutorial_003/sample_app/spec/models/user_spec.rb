require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user){ User.new(name:"konosuke matsuura", email:"konosuke.matsuura@gmail.com", 
                 password: "foobar", password_confirmation: "foobar") } 
  describe "validation" do 
    it "valid" do
      expect(user).to be_valid
    end

    it "name should be present" do
      user.name = "    "
      user.valid?
      expect(user.errors.messages[:name]).to include "can't be blank"
    end

    it "email should be present" do
      user.email = "    "
      user.valid?
      expect(user.errors.messages[:email]).to include "can't be blank"
    end

    it "name should not be too long" do
      user.name = "a" * 51
      user.valid?
      expect(user.errors.messages[:name]).to include "is too long (maximum is 50 characters)"
    end

    it "email should not be too long" do
      user.email = "a" * 244 + "@example.com"
      user.valid?
      expect(user.errors.messages[:email]).to include "is too long (maximum is 255 characters)"
    end

    it "email validation should accept valid addresses" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |address|
        user.email = address
        expect(user).to be_valid
      end
    end

    it "email validation should reject valid addresses" do
      valid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      valid_addresses.each do |address|
        user.email = address
        expect(user).to_not be_valid
      end
    end

    it "email addresses should be unique" do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save
      expect(duplicate_user).to_not be_valid
    end

    it "email addresses should be saved as lower-case" do
      mixed_case_email = "Foo@ExAMPle.CoM"
      user.email = mixed_case_email
      user.save
      user.reload
      expect(user.email).to eq mixed_case_email.downcase
    end

    it "password should be present (nonblank)" do
      user.password = " " * 6
      user.password_confirmation = " " * 6
      user.valid?
      expect(user.errors.messages[:password]).to include "can't be blank"
    end

    it "password should have a minimum length" do
      user.password = "a" * 5
      user.password_confirmation = "a" * 5
      user.valid?
      expect(user.errors.messages[:password]).to include "is too short (minimum is 6 characters)"
    end

  end

  describe "remember" do 
    it "remember_digestが保存されること" do 
      user.remember
      expect(user.remember_digest).to_not eq nil
    end
  end

  describe "authenticated?" do 
    it "remenber_token一致" do 
      user.remember
      expect(user.authenticated?(user.remember_token)).to be true
    end

    it "remenber_token不一致" do 
      user.remember
      expect(user.authenticated?('')).to be false
    end

    it "remenber_digestがnil" do 
      user.update_attribute(:remember_digest, nil)
      expect(user.authenticated?('')).to be false
    end
  end

  describe "forget" do 
    it "rememner_digestがnil" do 
      user.update_attribute(:remember_digest, nil)
      user.forget
      expect(user.remember_digest).to eq nil
    end

    it "rememner_digestがnil以外" do 
      user.remember
      user.forget
      expect(user.remember_digest).to eq nil
    end
  end
end
