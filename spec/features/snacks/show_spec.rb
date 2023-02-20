require 'rails_helper'

RSpec.describe 'When a user visits a snack show page', type: :feature do
	before do
		@owner = Owner.create!(name: "Sam's Snacks")
    @dons  = @owner.machines.create!(location: "Don's Mixed Drinks")
    @bowling  = @owner.machines.create!(location: "Bowling Alley")
    @skate  = @owner.machines.create!(location: "Skating Rink")
		@vodka = Snack.create!(name: "Vodka Lemonade", price: 5.50)
		@rum = Snack.create!(name: "Rum and Coke", price: 6)
		@gin = Snack.create!(name: "Negroni", price: 8.25)
		MachineSnack.create!(machine: @dons, snack: @vodka)
		MachineSnack.create!(machine: @dons, snack: @rum)
		MachineSnack.create!(machine: @bowling, snack: @rum)
		MachineSnack.create!(machine: @bowling, snack: @gin)
		MachineSnack.create!(machine: @skate, snack: @gin)
		MachineSnack.create!(machine: @skate, snack: @vodka)
	end

  scenario 'they see the name of that snack' do
		visit snack_path(@vodka)
		expect(page).to have_content("Vodka Lemonade")
		visit snack_path(@rum)
		expect(page).to have_content("Rum and Coke")
		
  end

  scenario 'they see the price of that snack' do
		visit snack_path(@vodka)
		expect(page).to have_content("Price: $5.50")
		visit snack_path(@gin)
		expect(page).to have_content("Price: $8.25")
  end

  scenario 'see a list of locations with vending machines that carry that snack' do
		visit snack_path(@vodka)
		within '#locations' do
			expect(page).to have_content("Don's Mixed Drinks")
			expect(page).to have_content("Skating Rink")
	end

		visit snack_path(@rum)
		within 'div#locations' do
			expect(page).to have_content("Don's Mixed Drinks")
			expect(page).to have_content("Bowling Alley")
		end
  end

  scenario 'they see the average price for snacks in those vending machines' do
		visit snack_path(@vodka)
		within "div#locations-#{@dons.id}" do
			expect(page).to have_content("average price of $5.75")
		end
		within "div#locations-#{@skate.id}" do
			expect(page).to have_content("average price of $6.88")
		end
		visit snack_path(@rum)
		within "div#locations-#{@bowling.id}" do
			expect(page).to have_content("average price of $7.13")
		end
  end

  scenario 'they see a count of the different kinds of items in that vending machine' do
		old= @skate.snacks.create!(name: "Old Fashioned", price: 8.25)
		visit snack_path(@vodka)		

		within "div#locations-#{@dons.id}" do
			expect(page).to have_content("2 kinds of snacks")
			expect(page).to_not have_content("3 kinds of snacks")
		end

		within "div#locations-#{@skate.id}" do
			expect(page).to have_content("3 kinds of snacks")
			expect(page).to_not have_content("2 kinds of snacks")
		end
  end
end