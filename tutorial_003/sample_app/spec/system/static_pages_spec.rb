require 'rails_helper'

RSpec.describe "StaticPages UI Test", type: :system do
  before do
    driven_by(:rack_test)
  end
  
  let(:base_title){ "Ruby on Rails Tutorial Sample App" }

  it "/static_pages/home title OK?" do
    visit "/static_pages/home"
    expect(page.title).to eq "#{base_title}"
  end

  it "/static_pages/help title OK?" do
    visit "/static_pages/help"
    expect(page.title).to eq "Help | #{base_title}"
  end

  it "/static_pages/about title OK?" do
    visit "/static_pages/about"
    expect(page.title).to eq "About | #{base_title}"
  end

  it "/static_pages/contact title OK?" do
    visit "/static_pages/contact"
    expect(page.title).to eq "Contact | #{base_title}"
  end

#  pending "add some scenarios (or delete) #{__FILE__}"
end
