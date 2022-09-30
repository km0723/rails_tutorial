require 'rails_helper'

RSpec.describe "シナリオテスト", type: :system do
  before do
    driven_by(:rack_test)
  end

  fixtures :users
  let(:michael){ users(:michael) }

  describe "login" do 
    context "正常系" do
      it "ログインでき/users/*へリダイレクトされること" do
        login
        expect(current_path).to include "/users/"
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

      it "cookieへ認証情報を保持していること" do
        login
        expire_cookies
        visit current_path
        within "header" do
          expect(page).to have_content "Account"
        end          
      end

      it "cookieへ認証情報を保持していない場合にブラウザ再起動でログイン状態が解除されること" do
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
        fill_in "Email", with: michael.email
        fill_in "Password", with: "xxpassword"
        click_button "Log in"
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

  describe "logout" do
    context "ログイン済み" do
      it "ログアウトでき/へリダイレクトされること" do
        login
        click_link 'Log out'
        expect(current_path).to eq "/"
      end

      it "ログアウト後ヘッダ" do
        login
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

    context "未ログイン" do
      it "該当テストなし" do
      end
    end
  end

  describe "Home" do
    context "ログイン済み" do
      before do
        login
      end
      it "Home画面へ遷移できること" do 
        click_link "Home"
        expect(current_path).to eq "/"
      end
    end

    context "未ログイン" do
      it "Home画面へ遷移できること" do 
        visit root_path
        click_link "Home"
        expect(current_path).to eq "/"
      end
    end
  end

  describe "Help" do
    context "ログイン済み" do
      before do
        login
      end
      it "Help画面へ遷移できること" do 
        click_link "Help"
        expect(current_path).to eq "/help"
      end
    end

    context "未ログイン" do
      it "Help画面へ遷移できること" do 
        visit root_path
        click_link "Help"
        expect(current_path).to eq "/help"
      end
    end
  end

  describe "signup" do
    context "ログイン済み" do
      before do
        login
      end
      it "ユーザ登録でき/users/*へリダイレクトされログイン状態となること" do
        visit root_path
        click_on "Sign up now!"
        fill_in "Name", with: "Konosuke Matsuura"
        fill_in "Email", with: "konosuke.matsuura@gmail.com"
        fill_in "Password", with: "mypassword"
        fill_in "Password confirmation", with: "mypassword"

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

    context "未ログイン" do
      it "ユーザ登録でき/users/*へリダイレクトされログイン状態となること" do
        visit root_path
        click_on "Sign up now!"
        fill_in "Name", with: "Konosuke Matsuura"
        fill_in "Email", with: "konosuke.matsuura@gmail.com"
        fill_in "Password", with: "mypassword"
        fill_in "Password confirmation", with: "mypassword"

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
  end

  describe "Profile" do
    context "ログイン済み" do
      before do
        login
      end
      it "該当ユーザのプロフィールページへ遷移できること" do
        click_link "Profile"
        expect(current_path).to eq "/users/#{michael.id}"
      end
    end

    context "未ログイン" do
      it "該当ユーザのプロフィールページへ遷移できること" do
        visit user_path michael
        expect(current_path).to eq "/users/#{michael.id}"
      end
    end
  end

  describe "Settings" do
    context "ログイン済み" do
      before do
        login
        visit edit_user_path(michael)
        fill_in "Name", with: "upd michael"
        fill_in "Email", with: "upd_michael@example.com"
        fill_in "Password", with: "updpassword"
        fill_in "Password confirmation", with: "updpassword"
        click_button "Save changes"
      end

      it "Name , Email , Password が更新できること" do
        michael.reload
        expect(michael.name).to eq "upd michael"
        expect(michael.email).to eq "upd_michael@example.com"
        expect(BCrypt::Password.new(michael.password_digest).is_password?("updpassword"))
      end

      it "更新後/users/*へリダイレクトされること" do
        expect(current_path).to eq "/users/#{michael.id}"
      end

      it "更新成功のメッセージがが初回のみ表示されること" do
        expect(page).to have_content "Success to Update!"
        visit current_path
        expect(page).to_not have_content "Success to Update!" 
      end
    end

    context "未ログイン" do
      it "ログインなしではプロフィール更新画面に到達できず/loginへリダイレクトされること" do
        visit edit_user_path(users(:konosuke))
        expect(current_path).to eq login_path
      end
      
      it "ログインユーザ以外のプロフィール更新画面に到達できず/へリダイレクトされること" do
        login
        visit edit_user_path(users(:konosuke))
        expect(current_path).to eq root_path
      end

      it "ログインせずプロフィール更新→ログインした時にプロフィール更新画面にリダイレクトされること" do
        visit edit_user_path(michael)
        login
        expect(current_path).to eq "/users/#{michael.id}/edit"
      end
    end
  end

  describe "uesrs" do
    context "ログイン済み" do
      before do
        login
      end
      it "ユーザの一覧画面へ遷移できること" do
        click_link "Users"
        expect(current_path).to eq "/users"
      end

      it "ページネーションできること" do
        click_link "Users"
        User.paginate(page: 1).each do |user|
          expect(page).to have_link user.name, href: user_path(user)
        end
    
        within all(".pagination")[0] do
          click_link "Next →"
        end
    
        User.paginate(page: 2).each do |user|
         expect(page).to have_link user.name, href: user_path(user)
        end
    
        within all(".pagination")[0] do
          click_link "← Previous"
        end
        User.paginate(page: 1).each do |user|
         expect(page).to have_link user.name, href: user_path(user)
        end
      end

      it "管理ユーザでログイン -> deleteリンクが表示されること" do
        click_link "Users"
        expect(page).to have_link "delete"
      end

      it "一般ユーザでログイン -> deleteリンクが表示されないこと" do
        visit login_path
        fill_in 'Email', with: users(:konosuke).email
        fill_in 'Password', with: 'mypassword'    
        click_button 'Log in'    
        click_link "Users"
        expect(page).to_not have_link "delete"
      end

      it "ユーザ削除が行えること" do
        click_link "Users"
        expect{
          click_link "delete", href: user_path(users(:lana))
        }.to change { User.count }.by(-1)      
      end
    end

    context "未ログイン" do
      it "ユーザの一覧画面へ遷移できず/loginへリダイレクトされること" do
        visit users_path
        expect(current_path).to eq "/login"
      end
    end
  end

  describe "Signup" do 
    context "異常系" do
      it "ユーザ登録 - Name 未入力でエラーとなりユーザ登録されないこと" do
        visit signup_path
        fill_in "Name", with: " "
        fill_in "Email", with: "konosuke.matsuura@gmail.com"
        fill_in "Password", with: "mypassword"
        fill_in "Password confirmation", with: "mypassword"
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Name can't be blank"
      end

      it "ユーザ登録 - Email 未入力でエラーとなりユーザ登録されないこと" do
        visit signup_path
        fill_in "Name", with: "konosuke matsuura"
        fill_in "Email", with: " "
        fill_in "Password", with: "mypassword"
        fill_in "Password confirmation", with: "mypassword"
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Email can't be blank"
      end

      it "ユーザ登録 - Email 形式不正でエラーとなりユーザ登録されないこと" do
        visit signup_path
        fill_in "Name", with: "konosuke matsuura"
        fill_in "Email", with: "konosuke.matsuura@gmail,com"
        fill_in "Password", with: "mypassword"
        fill_in "Password confirmation", with: "mypassword"
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Email is invalid"
      end

      it "ユーザ登録 - Email 多重登録でエラーとなりユーザ登録されないこと" do
        visit signup_path
        fill_in "Name", with: michael.name
        fill_in "Email", with: michael.email
        fill_in "Password", with: "mypassword"
        fill_in "Password confirmation", with: "mypassword"
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Email has already been taken"
      end

      it "ユーザ登録 - Password 未入力でエラーとなりユーザ登録されないこと" do
        visit signup_path
        fill_in "Name", with: "konosuke matsuura"
        fill_in "Email", with: "konosuke.matsuura@gmail.com"
        fill_in "Password", with: " "
        fill_in "Password confirmation", with: "mypassword"
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Password can't be blank"
      end

      it "ユーザ登録 - Password confirmation 未入力でエラーとなりユーザ登録されないこと" do
        visit signup_path
        fill_in "Name", with: "konosuke matsuura"
        fill_in "Email", with: "konosuke.matsuura@gmail.com"
        fill_in "Password", with: "mypassword"
        fill_in "Password confirmation", with: " "
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Password confirmation doesn't match Password"
      end

      it "ユーザ登録 - Password , Password confirmation 不一致でエラーとなりユーザ登録されないこと" do
        visit signup_path
        fill_in "Name", with: "konosuke matsuura"
        fill_in "Email", with: "konosuke.matsuura@gmail.com"
        fill_in "Password", with: "mypassword"
        fill_in "Password confirmation", with: "typo"
        expect{
          click_on "Create my account"
        }.to change { User.count }.by(0)
        expect(page).to have_content "Password confirmation doesn't match Password"
      end
    end
  end

  describe "logout" do 
    context "異常系" do
      it "該当テストなし" do
      end
    end
  end

  describe "update" do
    context "異常系" do
      it "空白" do
        login
        visit edit_user_path(michael)
        fill_in "Name", with: " "
        fill_in "Email", with: " "
        fill_in "Password", with: " "
        fill_in "Password confirmation", with: " "
        click_button "Save changes"
        expect(page).to have_content "Name can't be blank"
        expect(page).to have_content "Email can't be blank"
        expect(page).to have_content "Email is invalid"
        expect(page).to have_content "Password can't be blank"
        expect(page).to have_content "Password is too short (minimum is 6 characters)"
      end

      it "必須項目未入力" do
        login
        visit edit_user_path(michael)
        fill_in "Name", with: ""
        fill_in "Email", with: ""
        fill_in "Password", with: ""
        fill_in "Password confirmation", with: ""
        click_button "Save changes"
        expect(page).to have_content "Name can't be blank"
        expect(page).to have_content "Email can't be blank"
        expect(page).to have_content "Email is invalid"
        expect(page).to_not have_content "Password can't be blank"
        expect(page).to_not have_content "Password is too short (minimum is 6 characters)"
      end

      it "Password , Password confirmation 不一致" do
        login
        visit edit_user_path(michael)
        fill_in "Password", with: "mypassword"
        fill_in "Password confirmation", with: "misspassword"
        click_button "Save changes"
        expect(page).to have_content "Password confirmation doesn't match Password"
      end
    end
  end

  describe "users" do
    context "異常系" do
      it "該当テストなし" do
      end
    end
  end
end
