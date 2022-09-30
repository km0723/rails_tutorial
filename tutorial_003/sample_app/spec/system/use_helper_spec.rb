require 'rails_helper'

RSpec.describe "use helper spec", type: :system do
  before do
    driven_by(:rack_test)
  end

  fixtures :users
  let(:michael){ users(:michael) }

  # it "use helper" do
  #   login
  #   expect(current_path).to include '/users/'
  # end

  it "test pagination" do
    login
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

end
