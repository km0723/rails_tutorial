require 'rails_helper'

RSpec.describe "StaticPages Request Test", type: :request do
  describe "GET /" do
    it "200OK?" do
      get root_url
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /static_pages/home" do
    it "200OK?" do
      get static_pages_home_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /static_pages/help" do
    it "200OK?" do
      get static_pages_help_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /static_pages/about" do
    it "200OK?" do
      get static_pages_about_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /static_pages/contact" do
    it "200OK?" do
      get static_pages_contact_path
      expect(response).to have_http_status(200)
    end
  end

end
