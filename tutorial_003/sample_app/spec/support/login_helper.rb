module LoginHelper

  def login(remember: true)
    visit login_path
    fill_in 'Email', with: michael.email
    fill_in 'Password', with: 'mypassword'

    if remember
      check "Remember me on this computer"
    else
      uncheck "Remember me on this computer" 
    end
    
    click_button 'Log in'
  end
end