require "rails_helper"

RSpec.describe "/contacts routes" do
  it "routes to contacts#index" do
    expect(get "contacts").to route_to("contacts#index")
  end

  it "routes to contactsnew" do
    expect(get "contacts/new").to route_to("contacts#new")
  end

  it "routes to contacts#create" do
    expect(post "contacts").to route_to("contacts#create")
  end
end