FactoryBot.define do
  factory(:partner) do
    name Faker::Company.name
    # admin_email nil
    # admin_name nil
    # image nil
    # public_email nil
    # public_phone nil
    # short_description nil
    after(:build) { |partner| partner.turfs = [create(:turf)] }
  end
end
