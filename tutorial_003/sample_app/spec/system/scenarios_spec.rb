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
        fill_in 'Password confirmation', with: 'mypassword'

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
        fill_in 'Password confirmation', with: 'mypassword'
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
        fill_in 'Password confirmation', with: 'mypassword'
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
        fill_in 'Password confirmation', with: 'mypassword'
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
        fill_in 'Password confirmation', with: 'mypassword'
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
        fill_in 'Password confirmation', with: 'mypassword'
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Password can't be blank"
      end

      it "ユーザ登録 - Password confirmation 未入力でエラーとなりユーザ登録されないこと" do
        visit signup_path
        fill_in 'Name', with: 'konosuke matsuura'
        fill_in 'Email', with: 'konosuke.matsuura@gmail.com'
        fill_in 'Password', with: 'mypassword'
        fill_in 'Password confirmation', with: ' '
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Password confirmation doesn't match Password"
      end

      it "ユーザ登録 - Password , Password confirmation 不一致でエラーとなりユーザ登録されないこと" do
        visit signup_path
        fill_in 'Name', with: 'konosuke matsuura'
        fill_in 'Email', with: 'konosuke.matsuura@gmail.com'
        fill_in 'Password', with: 'mypassword'
        fill_in 'Password confirmation', with: 'typo'
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Password confirmation doesn't match Password"
      end
    end
  end

  describe "ログイン" do 
    context "正常系" do
      it "ログインでき/users/*へリダイレクトされること" do
        login
        expect(current_path).to include '/users/'
      end

      it "ログイン後ヘッダ" do
        login
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

      it "check Remember me" do
        login
        expire_cookies
        visit current_path
        within "header" do
          expect(page).to have_content "Account"
        end          
      end

      it "uncheck Remember me" do
        login(remember: false)
        expire_cookies
        visit current_path
        within "header" do
          expect(page).to_not have_content "Account"
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

      it "ログイン不可 remember_token 不一致" do
        login

        # session削除
        expire_cookies

        # remember_token 再作成
        delete_cookie(:remember_token)
        create_cookie(:remember_token, "hogefuga")

        # remember_tokenが不一致となりログアウト状態になるかチェック
        visit current_path
        within "header" do
          expect(page).to_not have_content "Account"
        end
      end
    end
  end

  describe "ログアウト" do 
    context "正常系" do
      before do
        login
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

  describe "プロフィール更新" do
    context "正常系" do
      before do
        login
        visit edit_user_path(michael)
        fill_in 'Name', with: 'upd michael'
        fill_in 'Email', with: 'upd_michael@example.com'
        fill_in 'Password', with: 'updpassword'
        fill_in 'Password confirmation', with: 'updpassword'
        click_button 'Save changes'
      end

      it "アップデート結果" do
        michael.reload
        expect(michael.name).to eq "upd michael"
        expect(michael.email).to eq "upd_michael@example.com"
        expect(BCrypt::Password.new(michael.password_digest).is_password?("updpassword"))
      end

      it "リダイレクト先" do
        expect(current_path).to include "/users/"
      end

      it "Flashメッセージ 初回のみ表示" do
        expect(page).to have_content "Success to Update!"
        visit current_path
        expect(page).to_not have_content "Success to Update!" 
      end

    end

    context "異常系" do
      it "ブランク" do
        login
        visit edit_user_path(michael)
        fill_in 'Name', with: ' '
        fill_in 'Email', with: ' '
        fill_in 'Password', with: ' '
        fill_in 'Password confirmation', with: ' '
        click_button 'Save changes'
        expect(page).to have_content "Name can't be blank"
        expect(page).to have_content "Email can't be blank"
        expect(page).to have_content "Email is invalid"
        expect(page).to have_content "Password can't be blank"
        expect(page).to have_content "Password is too short (minimum is 6 characters)"
      end

      it "Password , Password confirmation 不一致" do
        login
        visit edit_user_path(michael)
        fill_in 'Password', with: 'mypassword'
        fill_in 'Password confirmation', with: 'misspassword'
        click_button 'Save changes'
        expect(page).to have_content "Password confirmation doesn't match Password"
      end

      it "ログインなしではプロフィール更新画面に到達できず/loginへリダイレクトされること" do
        visit edit_user_path(users(:konosuke))
        expect(current_path).to eq login_path
      end
      
      it "ログインユーザ以外のプロフィール更新画面に到達できず/loginへリダイレクトされること" do
        login
        visit edit_user_path(users(:konosuke))
        expect(current_path).to eq root_path
      end
    end

    context "異常系→正常系" do
      it "ログインせずプロフィール更新→ログインした時にプロフィール更新画面にリダイレクトされること" do
        visit edit_user_path(michael)
        login
        expect(current_path).to include("/users/") & include("/edit")
      end
    end


  end
end
