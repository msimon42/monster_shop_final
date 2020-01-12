require 'rails_helper'

RSpec.describe 'New Merchant Creation' do
  before :each do
    @admin = create :random_admin_user
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end
  describe 'As an Admin' do
    it 'I can link to a new merchant page from merchant index' do
      visit '/admin/merchants'

      click_button 'New Merchant'

      expect(current_path).to eq('/admin/merchants/new')
    end

    it 'I can use the new merchant form to create a new merchant' do
      visit '/admin/merchants/new'

      name = 'Megans Marmalades'
      address = '123 Main St'
      city = "Denver"
      state = "CO"
      zip = 80218

      fill_in 'Name', with: name
      fill_in 'Address', with: address
      fill_in 'City', with: city
      fill_in 'State', with: state
      fill_in 'Zip', with: zip

      click_button 'Create Merchant'

      expect(current_path).to eq('/admin/merchants')
      expect(page).to have_link(name)
    end

    it 'I can not create a merchant with an incomplete form' do
      visit '/admin/merchants/new'

      name = 'Megans Marmalades'

      fill_in 'Name', with: name

      click_button 'Create Merchant'

      expect(page).to have_content("address: [\"can't be blank\"]")
      expect(page).to have_content("city: [\"can't be blank\"]")
      expect(page).to have_content("state: [\"can't be blank\"]")
      expect(page).to have_content("zip: [\"can't be blank\"]")
      expect(page).to have_button('Create Merchant')
    end
  end
end
