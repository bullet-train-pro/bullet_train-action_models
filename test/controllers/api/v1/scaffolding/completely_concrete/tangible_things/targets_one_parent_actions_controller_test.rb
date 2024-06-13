require "controllers/api/v1/test"

class Api::V1::Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneParentActionsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @another_user = create(:onboarded_user)
    @absolutely_abstract_creative_concept = @user.current_team
    @other_absolutely_abstract_creative_concept = @another_user.current_team

    @completely_concrete_tangible_things_targets_one_parent_action =
      create(:scaffolding_completely_concrete_tangible_things_targets_one_parent_action,
        team: @team,
        created_by: @user.memberships.first)
    @other_completely_concrete_tangible_things_targets_one_parent_actions =
      create_list(:scaffolding_completely_concrete_tangible_things_targets_one_parent_action, 3,
        team: @another_user.current_team,
        created_by: @another_user.memberships.first)
  end

  def assert_proper_object_serialization(completely_concrete_tangible_things_targets_one_parent_action_data)
    completely_concrete_tangible_things_targets_one_parent_action = Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneParentAction.find(completely_concrete_tangible_things_targets_one_parent_action_data["id"])

    # 🚅 super scaffolding will insert new fields above this line.
    assert_equal completely_concrete_tangible_things_targets_one_parent_action_data["absolutely_abstract_creative_concept_id"], completely_concrete_tangible_things_targets_one_parent_action.absolutely_abstract_creative_concept_id
  end

  test "index" do
    get "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/completely_concrete/tangible_things/targets_one_parent_actions", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    completely_concrete_tangible_things_targets_one_parent_action_ids_returned = response.parsed_body.map { |completely_concrete_tangible_things_targets_one_parent_action| completely_concrete_tangible_things_targets_one_parent_action["id"] }
    assert_includes(completely_concrete_tangible_things_targets_one_parent_action_ids_returned, @completely_concrete_tangible_things_targets_one_parent_action.id)

    # But not returning other people's resources.
    assert_not_includes(completely_concrete_tangible_things_targets_one_parent_action_ids_returned, @other_completely_concrete_tangible_things_targets_one_parent_actions.first.id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    get "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_parent_actions/#{@completely_concrete_tangible_things_targets_one_parent_action.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_parent_actions/#{@completely_concrete_tangible_things_targets_one_parent_action.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    params = {access_token: access_token}
    targets_one_parent_actions_data = JSON.parse(build(:scaffolding_completely_concrete_tangible_things_targets_one_parent_action, team: nil, created_by: @user.memberships.first).to_json)
    targets_one_parent_actions_data = targets_one_parent_actions_data.slice("target_count", "scheduled_for", "created_by_id")
    params[:completely_concrete_tangible_things_targets_one_parent_action] = targets_one_parent_actions_data

    post "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/completely_concrete/tangible_things/targets_one_parent_actions", params: params
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body
    post "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/completely_concrete/tangible_things/targets_one_parent_actions",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    refute @completely_concrete_tangible_things_targets_one_parent_action.target_count

    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_parent_actions/#{@completely_concrete_tangible_things_targets_one_parent_action.id}", params: {
      access_token: access_token,
      completely_concrete_tangible_things_targets_one_parent_action: {
        target_count: 1
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @completely_concrete_tangible_things_targets_one_parent_action.reload
    assert_equal @completely_concrete_tangible_things_targets_one_parent_action.target_count, 1

    # Also ensure we can't do that same action as another user.
    put "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_parent_actions/#{@completely_concrete_tangible_things_targets_one_parent_action.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneParentAction.count", -1) do
      delete "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_parent_actions/#{@completely_concrete_tangible_things_targets_one_parent_action.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/scaffolding/completely_concrete/tangible_things/targets_one_parent_actions/#{@completely_concrete_tangible_things_targets_one_parent_action.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
