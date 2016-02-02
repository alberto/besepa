module Pages
  class Customers
    include Capybara::DSL

    def visit_page
      visit "/customers"
    end

    def create_customer customer
      click_on "Create customer"
      fill_in('Name', :with => customer[:name])
      fill_in('Reference', :with => customer[:reference])
      click_on "Create"
    end

    def has_customer? customer
      customer_element = find_customer_in_list customer
      customer_element.has_content?(customer[:name]) &&
        customer_element.has_content?(customer[:reference])
    end

    def show_details customer
      click_on customer[:reference]
      Customer.new
    end

    def marked_as_removed? customer
      customer_element = find_customer_in_list customer
      customer_element.find(:xpath, './/*[@data-qa="customer-list__customer-status"]').has_content? 'REMOVED'
    end

    def update_customer new_data, customer
      click_on "Edit"
      fill_in('Name', :with => new_data[:name])
      click_on "Update"
    end

    def has_customer_updated_with? new_customer_data, customer
      customer_element = find_customer_in_list customer
      customer_element.has_content? new_customer_data[:new_name]
    end

    private
    def find_customer_in_list customer
      reference = customer[:reference]
      find(:xpath, '//*[@data-qa="customers-list__customer"][.//a[text()="' + reference +'"]]')
    end
  end

  class Customer
    include Capybara::DSL

    def has_customer_details? customer
      #NOTE: check all customer properties here
      has_content?(customer[:name]) &&
      has_content?(customer[:reference])
    end

    def create_account account
      click_on "Create account"
      fill_in('Iban', :with => account[:iban])
      click_on "Create"
    end

    def delete_customer customer
      click_on "Delete"
    end
  end
end
