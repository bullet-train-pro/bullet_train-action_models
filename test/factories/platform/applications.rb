FactoryBot.define do
  factory :platform_application, class: "Platform::Application" do
    association :team
    sequence(:name) { |n| "OAuth App #{n}" }
    scopes { "read write delete" }
    redirect_uri { "https://example.com/redirect" }
  end
end
