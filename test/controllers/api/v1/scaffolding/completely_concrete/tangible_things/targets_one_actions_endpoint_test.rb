require "sidekiq/testing"
require "test_helper"
require "controllers/api/test"

class Api::V1::Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneActionsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    Sidekiq::Testing.inline!

    @absolutely_abstract_creative_concept = create(:scaffolding_absolutely_abstract_creative_concept, team: @team)
    @tangible_thing = create(:scaffolding_completely_concrete_tangible_thing, absolutely_abstract_creative_concept: @absolutely_abstract_creative_concept)
    @targets_one_action = create(:scaffolding_completely_concrete_tangible_things_targets_one_action, tangible_thing: @tangible_thing)
    @other_targets_one_actions = create_list(:scaffolding_completely_concrete_tangible_things_targets_one_action, 3)
  end

  def teardown
    super

    Sidekiq::Testing.fake!
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(targets_one_action_data)
    # Fetch the targets_one_action in question and prepare to compare it's attributes.
    targets_one_action = Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneAction.find(targets_one_action_data["id"])
    assert_equal targets_one_action_data["delay"], targets_one_action.delay
    assert_equal targets_one_action_data["emoji"], targets_one_action.emoji
    assert_equal targets_one_action_data["keep_receipt"], targets_one_action.keep_receipt
    assert_equal targets_one_action_data["target_count"], targets_one_action.target_count
    # TODO This doesn't work on the `create` test because the response comes back `0`, but by the time we get to this
    # check the background job has updated it to `3` in the model. Not sure how to fix this.
    # assert_equal targets_one_action_data["performed_count"], targets_one_action.performed_count
    assert_equal targets_one_action_data["created_by"], targets_one_action.created_by
    assert_equal targets_one_action_data["approved_by"], targets_one_action.approved_by
    # TODO We need to introduce a `assert_date_and_time_equal_enough` helper that works with `nil` and ignores
    # milliseconds for the following attributes:
    # assert_equal targets_one_action_data["scheduled_for"], targets_one_action.scheduled_for
    # assert_equal targets_one_action_data["started_at"], targets_one_action.started_at
    # assert_equal targets_one_action_data["completed_at"], targets_one_action.completed_at
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal targets_one_action_data["tangible_thing_id"], targets_one_action.tangible_thing_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/scaffolding/completely_concrete/tangible_things/#{@tangible_thing.id}/targets_one_actions", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    targets_one_action_ids_returned = response.parsed_body.dig("data").map { |targets_one_action| targets_one_action.dig("attributes", "id") }
    assert_includes(targets_one_action_ids_returned, @targets_one_action.id)

    # But not returning other people's resources.
    assert_not_includes(targets_one_action_ids_returned, @other_targets_one_actions[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_actions/#{@targets_one_action.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # Also ensure we can't do that same action as another user.
    get "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_actions/#{@targets_one_action.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    targets_one_action_data = Api::V1::Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneActionSerializer.new(build(:scaffolding_completely_concrete_tangible_things_targets_one_action, tangible_thing: nil)).serializable_hash.dig(:data, :attributes)
    targets_one_action_data.except!(:id, :tangible_thing_id, :created_at, :updated_at)

    post "/api/v1/scaffolding/completely_concrete/tangible_things/#{@tangible_thing.id}/targets_one_actions",
      params: targets_one_action_data.merge({access_token: access_token})

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # Also ensure we can't do that same action as another user.
    post "/api/v1/scaffolding/completely_concrete/tangible_things/#{@tangible_thing.id}/targets_one_actions",
      params: targets_one_action_data.merge({access_token: another_access_token})
    # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
    assert_response :forbidden
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_actions/#{@targets_one_action.id}", params: {
      access_token: access_token,
      delay: 5,
      emoji: "Alternative String Value",
      # 🚅 super scaffolding will also insert new fields above this line.
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # But we have to manually assert the value was properly updated.
    @targets_one_action.reload
    assert_equal @targets_one_action.delay, 5
    assert_equal @targets_one_action.emoji, "Alternative String Value"
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_actions/#{@targets_one_action.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneAction.count", -1) do
      delete "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_actions/#{@targets_one_action.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_actions/#{@targets_one_action.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end
end
