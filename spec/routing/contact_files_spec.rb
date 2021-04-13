require "rails_helper"

RSpec.describe "/contact_files routes" do
  it "routes to contact_files#index" do
    expect(get "contact_files").to route_to("contact_files#index")
  end

  it "routes to contact_files#create" do
    expect(post "contact_files").to route_to("contact_files#create")
  end

  it "routes to contact_files#destroy" do
    expect(delete "contact_files/1").to route_to("contact_files#destroy", id: "1")
  end

  it "routes to contact_file#new" do 
    expect(get "contact_files/new").to route_to("contact_files#new")
  end

  it "routes to contact_file#import" do 
    expect(post "contact_file/import/1").to route_to("contact_files#import", id: "1")
  end
end