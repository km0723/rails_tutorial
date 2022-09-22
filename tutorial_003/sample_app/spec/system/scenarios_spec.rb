require 'rails_helper'

RSpec.describe "シナリオテスト", type: :system do
  before do
    driven_by(:rack_test)
  end

  fixtures :users
  let(:michael){ users(:michael) }

  describe "ユーザ登録" do 
    context "正常系" do
      it "ユーザ登録でき/users/*へリダイレクトされログイン状態となること" do
        visit signup_path
        fill_in 'Name', with: 'Konosuke Matsuura'
        fill_in 'Email', with: 'konosuke.matsuura@gmail.com'
        fill_in 'Password', with: 'mypassword'
        fill_in 'Confirmation', with: 'mypassword'

        # ユーザ登録されること
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(1)

        # /users/* へリダイレクトされること
        expect(current_path).to include "/users/"

        # flashメッセージが表示されること
        expect(page).to have_content "Welcome to the Sample App!"
        
        # リロードしflashメッセージが再表示されないこと
        visit current_path
        expect(page).to_not have_content "Welcome to the Sample App!"
        
        # ログイン状態となること(間接的にsession登録されることを確認)
        within "header" do
          expect(page).to_not have_link "Log in"
          expect(page).to have_link "User"
        end
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
        visit signup_path
        fill_in 'Name', with: michael.name
        fill_in 'Email', with: michael.email
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

  describe "ログイン" do 
    context "正常系" do
      before do
        visit login_path
        fill_in 'Email', with: michael.email
        fill_in 'Password', with: 'mypassword'
      end

      it "ログインでき/users/*へリダイレクトされること" do
        click_button 'Log in'
        expect(current_path).to include '/users/'
      end

      it "ログイン後ヘッダ" do
        click_button 'Log in'
        within "header" do
          expect(page).to have_link "Home"
          expect(page).to have_link "Help"
          expect(page).to have_link "User"
          expect(page).to have_content "Account"
          expect(page).to have_link "Profile"
          expect(page).to have_link "Settings"
          expect(page).to have_link "Log out"
          expect(page).to_not have_link "Log in"
        end          
      end
    end

    context "異常系" do
      it "ログイン不可 Password 不一致" do
        visit login_path
        fill_in 'Email', with: michael.email
        fill_in 'Password', with: 'xxpassword'
        click_button 'Log in'
        expect(page).to have_content "Invalid email/password combination"

        visit current_path
        expect(page).to_not have_content "Invalid email/password combination"

      end
    end
  end

  describe "ログアウト" do 
    context "正常系" do
      before do
        visit login_path
        fill_in 'Email', with: michael.email
        fill_in 'Password', with: 'mypassword'
        click_button 'Log in'
      end

      it "ログアウトでき/へリダイレクトされること" do
        click_link 'Log out'
        expect(current_path).to eq '/'
      end

      it "ログアウト後ヘッダ" do
        click_link 'Log out'
        within "header" do
          expect(page).to have_link "Home"
          expect(page).to have_link "Help"
          expect(page).to have_link "Log in"
          expect(page).to_not have_content "Account"
          expect(page).to_not have_link "Profile"
          expect(page).to_not have_link "Settings"
          expect(page).to_not have_link "Log out"
        end
      end        
    end
  end
end
