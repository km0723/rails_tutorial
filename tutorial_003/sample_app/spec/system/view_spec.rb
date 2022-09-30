require 'rails_helper'

RSpec.xdescribe "View Test", type: :system do
  include ApplicationHelper

  before do
    driven_by(:rack_test)
  end
  
  context "header" do
    it "content" do
      visit root_path
      expect(page).to have_content "sample app"
      expect(page).to have_content "Home"
      expect(page).to have_content "Help"
      expect(page).to have_content "Log in"
    end

    it "link " do
      visit root_path
      click_link "sample app"
      expect(current_path).to eq "/"
      click_link "Home"
      expect(current_path).to eq "/"
      click_link "Help"
      expect(current_path).to eq "/help"
      #click_link "Log in"
      #expect(current_path).to eq "/help"
    end
  end

  context "footer" do
    it "content" do
      visit root_path
      expect(page).to have_content "The Ruby on Rails Tutorial by Michael Hartl"
      expect(page).to have_content "About"
      expect(page).to have_content "Contact"
      expect(page).to have_content "News"
    end

    it "link " do
      visit root_path
      click_link "About"
      expect(current_path).to eq "/about"
      click_link "Contact"
      expect(current_path).to eq "/contact"

      visit contact_path
      click_link "Ruby on Rails Tutorial"
      expect(current_url).to eq "https://railstutorial.jp/"

      visit root_path
      click_link "Michael Hartl"
      expect(current_url).to eq "https://www.michaelhartl.com/"

      visit root_path
      click_link "News"
      expect(current_url).to eq "https://news.railstutorial.org/"

    end
  end

  context "root" do
    it "title" do
      visit root_path
      expect(page.title).to eq full_title
    end

    it "body" do
      visit root_path
      expect(page).to have_content "Welcome to the Sample App"
      expect(page).to have_content "This is the home page for the Ruby on Rails Tutorial sample application."
      expect(page).to have_content "Sign up now!"
      expect(page).to have_link nil, href: "https://rubyonrails.org/"
    end

    it "link " do
      visit root_path
      within "h2" do
        click_link "Ruby on Rails Tutorial"
        expect(current_url).to eq "https://railstutorial.jp/"  
      end

      click_link nil, href: "https://rubyonrails.org/"
      expect(current_url).to eq "https://rubyonrails.org/"

      visit root_path
      click_link "Sign up now!"
      expect(current_path).to eq "/signup" 
    end
  end

  context "help" do
    it "title" do
      visit help_path
      expect(page.title).to eq full_title("Help")
    end

    it "body" do
      visit help_path
      expect(page).to have_content "Get help on the Ruby on Rails Tutorial at the Rails Tutorial help page. To get help on this sample app, see the Ruby on Rails Tutorial book."
    end

    it "link" do
      visit help_path
      click_link "Rails Tutorial help page"
      expect(current_url).to eq "https://railstutorial.jp/help"
 
      # TODO:
      visit help_path
      click_link "Ruby on Rails Tutorial book"
      expect("#{current_url}#ebook").to eq "https://railstutorial.jp/#ebook"
    end

  end

  context "about" do
    it "title" do
      visit about_path
      expect(page.title).to eq full_title("About")
    end

    it "body" do
      visit about_path
      expect(page).to have_content "Ruby on Rails Tutorial is a book and screencast to teach web development with Ruby on Rails. This is the sample application for the tutorial."
    end

    it "link" do
      visit about_path
      within "p" do
        click_link "Ruby on Rails Tutorial"
      end
      expect(current_url).to eq "https://railstutorial.jp/"

      visit about_path
      click_link "book"
      expect("#{current_url}#ebook").to eq "https://railstutorial.jp/#ebook"

      #visit about_path
      #click_link nil, href: "https://railstutorial.jp/screencast"
      #click_link "screencast"
      #expect(current_url).to include "https://railstutorial.jp/screencast"

      visit about_path
      click_link "Ruby on Rails"
      expect(current_url).to eq "https://rubyonrails.org/"
    end
  end

  context "contact" do
    it "title" do
      visit contact_path
      expect(page.title).to eq full_title("Contact")
    end

    it "body" do
      visit contact_path
      expect(page).to have_content "Contact the Ruby on Rails Tutorial about the sample app at the contact page."
    end

    it "link" do
      visit contact_path
      click_link "contact page"
      expect(current_url).to eq "https://railstutorial.jp/contact"
    end

  end

  context "signup" do
    it "title" do
      visit signup_path
      expect(page.title).to eq full_title("Sign up")
    end

    it "body" do
      visit signup_path
      expect(page).to have_content "This will be a signup page for new users."
    end

    it "link" do
      
    end

  end

#  pending "add some scenarios (or delete) #{__FILE__}"
end
