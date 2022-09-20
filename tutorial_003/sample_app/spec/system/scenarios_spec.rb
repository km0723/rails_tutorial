require 'rails_helper'

RSpec.describe "シナリオテスト", type: :system do
  before do
    driven_by(:rack_test)
  end
  describe "ユーザ登録" do 
    context "正常系" do
      it "ユーザ登録でき/users/*へリダイレクトされること" do
        visit signup_path
        fill_in 'Name', with: 'Konosuke Matsuura'
        fill_in 'Email', with: 'konosuke.matsuura@gmail.com'
        fill_in 'Password', with: 'mypassword'
        fill_in 'Confirmation', with: 'mypassword'

        expect{
          click_on "Create my account"
        }.to change { User.count }.by(1)

        expect(current_path).to include "/users/"

        expect(page).to have_content "Welcome to the Sample App!"
        
        visit current_path
        expect(page).to_not have_content "Welcome to the Sample App!"
      end

    end
    context "異常系" do
      it "ユーザ登録 - Name 未入力でエラーとなりユーザ登録されないこと" do
        visit signup_path
        fill_in 'Name', with: ' '
        fill_in 'Email', with: 'konosuke.matsuura@gmail.com'
        fill_in 'Password', with: 'mypassword'
        fill_in 'Confirmation', with: 'mypassword'
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Name can't be blank"
      end

      it "ユーザ登録 - Email 未入力でエラーとなりユーザ登録されないこと" do
        visit signup_path
        fill_in 'Name', with: 'konosuke matsuura'
        fill_in 'Email', with: ' '
        fill_in 'Password', with: 'mypassword'
        fill_in 'Confirmation', with: 'mypassword'
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Email can't be blank"
      end

      it "ユーザ登録 - Email 形式不正でエラーとなりユーザ登録されないこと" do
        visit signup_path
        fill_in 'Name', with: 'konosuke matsuura'
        fill_in 'Email', with: 'konosuke.matsuura@gmail,com'
        fill_in 'Password', with: 'mypassword'
        fill_in 'Confirmation', with: 'mypassword'
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Email is invalid"
      end

      it "ユーザ登録 - Email 多重登録でエラーとなりユーザ登録されないこと" do
        User.create(
          name: 'konosuke matsuura',
          email: 'konosuke.matsuura@gmail.com',
          password: 'mypassword',
          password_confirmation: 'mypassword'
        )

        visit signup_path
        fill_in 'Name', with: 'konosuke matsuura'
        fill_in 'Email', with: 'konosuke.matsuura@gmail.com'
        fill_in 'Password', with: 'mypassword'
        fill_in 'Confirmation', with: 'mypassword'
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Email has already been taken"
      end

      it "ユーザ登録 - Password 未入力でエラーとなりユーザ登録されないこと" do
        visit signup_path
        fill_in 'Name', with: 'konosuke matsuura'
        fill_in 'Email', with: 'konosuke.matsuura@gmail.com'
        fill_in 'Password', with: ' '
        fill_in 'Confirmation', with: 'mypassword'
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Password can't be blank"
      end

      it "ユーザ登録 - Confirmation 未入力でエラーとなりユーザ登録されないこと" do
        visit signup_path
        fill_in 'Name', with: 'konosuke matsuura'
        fill_in 'Email', with: 'konosuke.matsuura@gmail.com'
        fill_in 'Password', with: 'mypassword'
        fill_in 'Confirmation', with: ' '
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Password confirmation doesn't match Password"
      end

      it "ユーザ登録 - Password , Confirmation 不一致でエラーとなりユーザ登録されないこと" do
        visit signup_path
        fill_in 'Name', with: 'konosuke matsuura'
        fill_in 'Email', with: 'konosuke.matsuura@gmail.com'
        fill_in 'Password', with: 'mypassword'
        fill_in 'Confirmation', with: 'typo'
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Password confirmation doesn't match Password"
      end
    end
  end
end
