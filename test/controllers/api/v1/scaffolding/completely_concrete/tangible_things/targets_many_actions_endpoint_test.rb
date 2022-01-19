require "test_helper"
require "controllers/api/test"

class Api::V1::Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyActionsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    Sidekiq::Testing.inline!

    @absolutely_abstract_creative_concept = create(:scaffolding_absolutely_abstract_creative_concept, team: @team)
    @targets_many_action = create(:scaffolding_completely_concrete_tangible_things_targets_many_action, absolutely_abstract_creative_concept: @absolutely_abstract_creative_concept)
    @other_targets_many_actions = create_list(:scaffolding_completely_concrete_tangible_things_targets_many_action, 3)
  end

  def teardown
    super

    Sidekiq::Testing.fake!
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(targets_many_action_data)
    # Fetch the targets_many_action in question and prepare to compare it's attributes.
    targets_many_action = Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyAction.find(targets_many_action_data["id"])

    assert_equal targets_many_action_data["target_all"], targets_many_action.target_all
    assert_equal targets_many_action_data["target_ids"], targets_many_action.target_ids
    assert_equal targets_many_action_data["emoji"], targets_many_action.emoji
    assert_equal targets_many_action_data["delay"], targets_many_action.delay
    assert_equal targets_many_action_data["keep_receipt"], targets_many_action.keep_receipt
    assert_equal targets_many_action_data["target_count"], targets_many_action.target_count
    assert_equal targets_many_action_data["performed_count"], targets_many_action.performed_count
    assert_equal targets_many_action_data["created_by_id"], targets_many_action.created_by_id
    assert_equal targets_many_action_data["approved_by_id"], targets_many_action.approved_by_id
    # TODO We need to introduce a `assert_date_and_time_equal_enough` helper that works with `nil` and ignores
    # milliseconds for the following attributes:
    # assert_equal targets_one_action_data["scheduled_for"], targets_one_action.scheduled_for
    # assert_equal targets_one_action_data["started_at"], targets_one_action.started_at
    # assert_equal targets_one_action_data["completed_at"], targets_one_action.completed_at
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal targets_many_action_data["absolutely_abstract_creative_concept_id"], targets_many_action.absolutely_abstract_creative_concept_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/completely_concrete/tangible_things/targets_many_actions", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    targets_many_action_ids_returned = response.parsed_body.dig("data").map { |targets_many_action| targets_many_action.dig("attributes", "id") }
    assert_includes(targets_many_action_ids_returned, @targets_many_action.id)

    # But not returning other people's resources.
    assert_not_includes(targets_many_action_ids_returned, @other_targets_many_actions[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/scaffolding/completely_concrete/tangible_things/targets_many_actions/#{@targets_many_action.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # Also ensure we can't do that same action as another user.
    get "/api/v1/scaffolding/completely_concrete/tangible_things/targets_many_actions/#{@targets_many_action.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    targets_many_action_data = Api::V1::Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyActionSerializer.new(build(:scaffolding_completely_concrete_tangible_things_targets_many_action, absolutely_abstract_creative_concept: nil)).serializable_hash.dig(:data, :attributes)
    targets_many_action_data.except!(:id, :absolutely_abstract_creative_concept_id, :created_at, :updated_at)

    post "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/completely_concrete/tangible_things/targets_many_actions",
      params: targets_many_action_data.merge({access_token: access_token})

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # Also ensure we can't do that same action as another user.
    post "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/completely_concrete/tangible_things/targets_many_actions",
      params: targets_many_action_data.merge({access_token: another_access_token})
    # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
    assert_response :forbidden
  end

  test "update" do
    # TODO Going to have Nick look at why this is failing.
    skip

    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/scaffolding/completely_concrete/tangible_things/targets_many_actions/#{@targets_many_action.id}", params: {
      access_token: access_token,
      delay: 1,
      # 🚅 super scaffolding will also insert new fields above this line.
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # But we have to manually assert the value was properly updated.
    @targets_many_action.reload
    assert_equal @targets_many_action.delay, 1
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/scaffolding/completely_concrete/tangible_things/targets_many_actions/#{@targets_many_action.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyAction.count", -1) do
      delete "/api/v1/scaffolding/completely_concrete/tangible_things/targets_many_actions/#{@targets_many_action.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/scaffolding/completely_concrete/tangible_things/targets_many_actions/#{@targets_many_action.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end
end
