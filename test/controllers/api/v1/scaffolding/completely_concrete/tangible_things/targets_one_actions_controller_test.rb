require "controllers/api/v1/test"

class Api::V1::Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneActionsControllerTest < Api::Test
  def setup
    skip "FIX ME"
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @another_user = create(:onboarded_user)
    @completely_concrete_tangible_thing = create(:completely_concrete_tangible_thing, team: @team)
    @other_completely_concrete_tangible_thing = create(:completely_concrete_tangible_thing, team: @another_user.current_team)

    @completely_concrete_tangible_things_targets_one_action =
      create(:completely_concrete_tangible_things_targets_one_action,
        team: @team,
        completely_concrete_tangible_thing: @completely_concrete_tangible_thing,
        created_by: @user.memberships.first)
    @other_completely_concrete_tangible_things_targets_one_actions =
      create_list(:completely_concrete_tangible_things_targets_one_action, 3,
        team: @another_user.current_team,
        completely_concrete_tangible_thing: @other_completely_concrete_tangible_thing,
        created_by: @another_user.memberships.first)
  end

  def assert_proper_object_serialization(completely_concrete_tangible_things_targets_one_action_data)
    completely_concrete_tangible_things_targets_one_action = Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneAction.find(completely_concrete_tangible_things_targets_one_action_data["id"])

    # 🚅 super scaffolding will insert new fields above this line.
    assert_equal completely_concrete_tangible_things_targets_one_action_data["completely_concrete_tangible_thing_id"], completely_concrete_tangible_things_targets_one_action.completely_concrete_tangible_thing_id
  end

  test "index" do
    get "/api/v1/scaffolding/completely_concrete/tangible_things/#{@completely_concrete_tangible_thing.id}/targets_one_actions", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    completely_concrete_tangible_things_targets_one_action_ids_returned = response.parsed_body.map { |completely_concrete_tangible_things_targets_one_action| completely_concrete_tangible_things_targets_one_action["id"] }
    assert_includes(completely_concrete_tangible_things_targets_one_action_ids_returned, @completely_concrete_tangible_things_targets_one_action.id)

    # But not returning other people's resources.
    assert_not_includes(completely_concrete_tangible_things_targets_one_action_ids_returned, @other_completely_concrete_tangible_things_targets_one_actions.first.id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    get "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_actions/#{@completely_concrete_tangible_things_targets_one_action.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_actions/#{@completely_concrete_tangible_things_targets_one_action.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    params = {access_token: access_token}
    targets_one_actions_data = JSON.parse(build(:completely_concrete_tangible_things_targets_one_action, team: nil, created_by: @user.memberships.first).to_json)
    targets_one_actions_data = targets_one_actions_data.slice("target_count", "scheduled_for", "created_by_id")
    params[:completely_concrete_tangible_things_targets_one_action] = targets_one_actions_data

    post "/api/v1/scaffolding/completely_concrete/tangible_things/#{@completely_concrete_tangible_thing.id}/targets_one_actions", params: params
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body
    post "/api/v1/scaffolding/completely_concrete/tangible_things/#{@completely_concrete_tangible_thing.id}/targets_one_actions",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    refute @completely_concrete_tangible_things_targets_one_action.target_count

    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_actions/#{@completely_concrete_tangible_things_targets_one_action.id}", params: {
      access_token: access_token,
      completely_concrete_tangible_things_targets_one_action: {
        target_count: 1
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @completely_concrete_tangible_things_targets_one_action.reload
    assert_equal @completely_concrete_tangible_things_targets_one_action.target_count, 1

    # Also ensure we can't do that same action as another user.
    put "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_actions/#{@completely_concrete_tangible_things_targets_one_action.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneAction.count", -1) do
      delete "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_actions/#{@completely_concrete_tangible_things_targets_one_action.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_actions/#{@completely_concrete_tangible_things_targets_one_action.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
