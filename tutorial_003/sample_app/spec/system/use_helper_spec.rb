require 'rails_helper'

RSpec.describe "use helper spec", type: :system do
  before do
    driven_by(:rack_test)
  end

  fixtures :users
  let(:michael){ users(:michael) }

  it "use helper" do
    login
    expect(current_path).to include '/users/'
  end
end
