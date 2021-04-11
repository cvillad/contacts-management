require "rails_helper"

RSpec.describe "/failed_contacts routes" do
  it "routes to failed_contacts#index" do 
    expect(get "/failed_contacts").to route_to("failed_contacts#index")
  end
end