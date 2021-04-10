module ControllerMacros  
  include Warden::Test::Helpers

  def self.included(base)
    base.before(:each) { Warden.test_mode! }
    base.after(:each) { Warden.test_reset! }
  end

  def sign_in(resource)
    login_as(resource, scope: warden_scope(resource))
  end

  def sign_out(resource)
    logout(warden_scope(resource))
  end

  def create_csv_file(file)
    csv_file = ActiveStorage::Blob.create_and_upload!(
        io: File.open(file, 'rb'),
        filename: 'valid_contacts.csv',
        content_type: 'text/csv'
    ).signed_id
  end
  private

  def warden_scope(resource)
    resource.class.name.underscore.to_sym
  end
end