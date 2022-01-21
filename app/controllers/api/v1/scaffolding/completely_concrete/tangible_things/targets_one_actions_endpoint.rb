class Api::V1::Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneActionsEndpoint < Api::V1::Root
  helpers do
    params :tangible_thing_id do
      requires :tangible_thing_id, type: Integer, allow_blank: false, desc: "Tangible Thing ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Targets One Action ID"
    end

    params :targets_one_action do
      optional :delay, type: String, desc: Api.heading(:delay)
      optional :scheduled_for, type: DateTime, desc: Api.heading(:scheduled_for)
      optional :emoji, type: String, desc: Api.heading(:emoji)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "scaffolding/completely_concrete/tangible_things", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneAction
    end

    #
    # INDEX
    #

    desc Api.title(:index), &Api.index_desc
    params do
      use :tangible_thing_id
    end
    oauth2
    paginate per_page: 100
    get "/:tangible_thing_id/targets_one_actions" do
      @paginated_targets_one_actions = paginate @targets_one_actions
      render @paginated_targets_one_actions, serializer: Api.serializer
    end

    #
    # CREATE
    #

    desc Api.title(:create), &Api.create_desc
    params do
      use :tangible_thing_id
      use :targets_one_action
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:tangible_thing_id/targets_one_actions" do
      # TODO We should probably employ Current Attributes in Rails and set this in the model, so the same thing is
      # happening automatically when we create an action via the web controller as well.
      @targets_one_action.created_by = current_membership

      if @targets_one_action.save
        render @targets_one_action, serializer: Api.serializer
      else
        record_not_saved @targets_one_action
      end
    end
  end

  resource "scaffolding/completely_concrete/tangible_things/targets_one_actions", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneAction
    end

    #
    # SHOW
    #

    desc Api.title(:show), &Api.show_desc
    params do
      use :id
    end
    oauth2
    route_param :id do
      get do
        render @targets_one_action, serializer: Api.serializer
      end
    end

    #
    # UPDATE
    #

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :targets_one_action
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @targets_one_action.update(declared(params, include_missing: false))
          render @targets_one_action, serializer: Api.serializer
        else
          record_not_saved @targets_one_action
        end
      end
    end

    #
    # DESTROY
    #

    desc Api.title(:destroy), &Api.destroy_desc
    params do
      use :id
    end
    route_setting :api_resource_options, permission: :destroy
    oauth2 "delete"
    route_param :id do
      delete do
        render @targets_one_action.destroy, serializer: Api.serializer
      end
    end
  end
end
