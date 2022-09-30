require 'rails_helper'

RSpec.describe "Users", type: :request do

  fixtures :users
  let(:normal_user){ users(:konosuke) }
  let(:admin_user){ users(:michael) }

  describe "new" do
    it "GET" do
      get signup_path
      expect(response).to have_http_status(200)
    end
  end

  describe "update" do
    before do
      post login_path , params: {session: {email: normal_user.email , password: 'mypassword' }}
    end
    it "adminパラメータが無視されること" do
      patch user_path normal_user , params: { user: { name: 'hogefuga', admin: true} }
      normal_user.reload
      expect(normal_user.name).to eq "hogefuga"
      expect(normal_user.admin?).to be false
    end
  end

  describe "destroy" do
    context "ログイン済み" do
      it "管理ユーザで削除できること" do
        post login_path , params: {session: {email: admin_user.email , password: 'mypassword' }}
        expect{
            delete user_path normal_user
        }.to change {User.count}.by(-1)
      end

      it "一般ユーザで削除できないこと" do
        post login_path , params: {session: {email: normal_user.email , password: 'mypassword' }}
        expect{
            delete user_path normal_user
        }.to change {User.count}.by(0)
      end
    end
    context "未ログイン" do
        it "管理ユーザで削除できないこと" do
            expect{
                delete user_path normal_user
            }.to change {User.count}.by(0)
        end
  
        it "一般ユーザで削除できないこと" do
            expect{
                delete user_path normal_user
            }.to change {User.count}.by(0)
        end
    end
  end
end
