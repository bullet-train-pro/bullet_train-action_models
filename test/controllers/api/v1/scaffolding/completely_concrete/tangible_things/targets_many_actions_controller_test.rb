require "controllers/api/v1/test"

if defined?(BulletTrain::ActionModels)
  class Api::V1::Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyActionsControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @completely_concrete_tangible_things = create_list(:completely_concrete_tangible_thing, 3, team: @team)
      @completely_concrete_tangible_things_targets_many_action =
        create(:completely_concrete_tangible_things_targets_many_action,
          team: @team,
          created_by: @user.memberships.first,
          target_ids: [@completely_concrete_tangible_things.first.id.to_s]
        )
      @completely_concrete_tangible_things_targets_many_action.perform_on_target(@projects.first)
    end

    def assert_proper_object_serialization(completely_concrete_tangible_things_targets_many_action_data)
      completely_concrete_tangible_things_targets_many_action = Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyAction.find(completely_concrete_tangible_things_targets_many_action_data["id"])

      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal completely_concrete_tangible_things_targets_many_action_data["team_id"], completely_concrete_tangible_things_targets_many_action.team_id
    end

    test "show" do
      get "/api/v1/scaffolding/completely_concrete/tangible_things/targets_many_actions/#{@completely_concrete_tangible_things_targets_many_action.id}", params: {access_token: access_token}
      assert_response :success

      assert_proper_object_serialization response.parsed_body
    end

    test "index" do
      get "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/projects/archive_actions", params: {access_token: access_token}
      assert_response :success
    end

    test "create" do
      params = {access_token: access_token}
      targets_many_actions_data = JSON.parse(build(:completely_concrete_tangible_things_targets_many_action, team: nil, created_by: @user.memberships.first).to_json)
      targets_many_actions_data = targets_many_actions_data.slice("target_all", "scheduled_for", "target_ids", "created_by_id")
      params[:completely_concrete_tangible_things_targets_many_action] = targets_many_actions_data

      post "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/scaffolding/completely_concrete/tangible_things/targets_many_actions", params: params
      assert_response :success
    end
  end
end
