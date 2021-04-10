require "rails_helper"

RSpec.describe "/contacts routes" do
  it "routes to contacts#index" do
    expect(get "contacts").to route_to("contacts#index")
  end

  it "routes to contacts#destroy" do
    expect(delete "contacts/1").to route_to("contacts#destroy", id: "1")
  end
end