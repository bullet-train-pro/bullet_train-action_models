require "test_helper"
require "controllers/api/test"

class Api::V1::Scaffolding::CompletelyConcrete::TangibleThings::PerformsImportActionsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    Sidekiq::Testing.inline!

    @absolutely_abstract_creative_concept = create(:scaffolding_absolutely_abstract_creative_concept, team: @team)
    @performs_import_action = create(:scaffolding_completely_concrete_tangible_things_performs_import_action, absolutely_abstract_creative_concept: @absolutely_abstract_creative_concept)
    @other_performs_import_actions = create_list(:scaffolding_completely_concrete_tangible_things_performs_import_action, 3)
  end

  def teardown
    super

    Sidekiq::Testing.fake!
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(performs_import_action_data)
    # Fetch the performs_import_action in question and prepare to compare it's attributes.
    performs_import_action = Scaffolding::CompletelyConcrete::TangibleThings::PerformsImportAction.find(performs_import_action_data["id"])

    assert_equal performs_import_action_data["target_all"], performs_import_action.target_all
    assert_equal performs_import_action_data["target_ids"], performs_import_action.target_ids
    assert_equal performs_import_action_data["emoji"], performs_import_action.emoji
    assert_equal performs_import_action_data["delay"], performs_import_action.delay
    assert_equal performs_import_action_data["target_count"], performs_import_action.target_count
    assert_equal performs_import_action_data["performed_count"], performs_import_action.performed_count
    assert_equal performs_import_action_data["created_by_id"], performs_import_action.created_by_id
    assert_equal performs_import_action_data["approved_by_id"], performs_import_action.approved_by_id
    # TODO We need to introduce a `assert_date_and_time_equal_enough` helper that works with `nil` and ignores
    # milliseconds for the following attributes:
    # assert_equal targets_one_action_data["scheduled_for"], targets_one_action.scheduled_for
    # assert_equal targets_one_action_data["started_at"], targets_one_action.started_at
    # assert_equal targets_one_action_data["completed_at"], targets_one_action.completed_at
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal performs_import_action_data["absolutely_abstract_creative_concept_id"], performs_import_action.absolutely_abstract_creative_concept_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/completely_concrete/tangible_things/performs_import_actions", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    performs_import_action_ids_returned = response.parsed_body.dig("data").map { |performs_import_action| performs_import_action.dig("attributes", "id") }
    assert_includes(performs_import_action_ids_returned, @performs_import_action.id)

    # But not returning other people's resources.
    assert_not_includes(performs_import_action_ids_returned, @other_performs_import_actions[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/scaffolding/completely_concrete/tangible_things/performs_import_actions/#{@performs_import_action.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # Also ensure we can't do that same action as another user.
    get "/api/v1/scaffolding/completely_concrete/tangible_things/performs_import_actions/#{@performs_import_action.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    performs_import_action_data = Api::V1::Scaffolding::CompletelyConcrete::TangibleThings::PerformsImportActionSerializer.new(build(:scaffolding_completely_concrete_tangible_things_performs_import_action, absolutely_abstract_creative_concept: nil)).serializable_hash.dig(:data, :attributes)
    performs_import_action_data.except!(:id, :absolutely_abstract_creative_concept_id, :created_at, :updated_at)

    post "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/completely_concrete/tangible_things/performs_import_actions",
      params: performs_import_action_data.merge({access_token: access_token})

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # Also ensure we can't do that same action as another user.
    post "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/completely_concrete/tangible_things/performs_import_actions",
      params: performs_import_action_data.merge({access_token: another_access_token})
    # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
    assert_response :forbidden
  end

  test "update" do
    # TODO Going to have Nick look at why this is failing.
    skip

    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/scaffolding/completely_concrete/tangible_things/performs_import_actions/#{@performs_import_action.id}", params: {
      access_token: access_token,
      delay: 1,
      # 🚅 super scaffolding will also insert new fields above this line.
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # But we have to manually assert the value was properly updated.
    @performs_import_action.reload
    assert_equal @performs_import_action.delay, 1
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/scaffolding/completely_concrete/tangible_things/performs_import_actions/#{@performs_import_action.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Scaffolding::CompletelyConcrete::TangibleThings::PerformsImportAction.count", -1) do
      delete "/api/v1/scaffolding/completely_concrete/tangible_things/performs_import_actions/#{@performs_import_action.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/scaffolding/completely_concrete/tangible_things/performs_import_actions/#{@performs_import_action.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end
end
