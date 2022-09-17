require 'rails_helper'

RSpec.describe "StaticPages Request Test", type: :request do
  describe "GET /" do
    it "200OK?" do
      get root_url
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /help" do
    it "200OK?" do
      get help_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /about" do
    it "200OK?" do
      get about_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /contact" do
    it "200OK?" do
      get contact_path
      expect(response).to have_http_status(200)
    end
  end

end
