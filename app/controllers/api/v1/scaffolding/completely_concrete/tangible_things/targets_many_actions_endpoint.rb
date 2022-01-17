class Api::V1::Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyActionsEndpoint < Api::V1::Root
  helpers do
    params :absolutely_abstract_creative_concept_id do
      requires :absolutely_abstract_creative_concept_id, type: Integer, allow_blank: false, desc: "Creative Concept ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Targets Many Action ID"
    end

    params :targets_many_action do
      # 🚅 skip this section when scaffolding.
      optional :emoji, type: String, desc: Api.heading(:emoji)
      # 🚅 stop any skipping we're doing now.
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      optional :target_all, type: Boolean, desc: Api.heading(:target_all)
      optional :keep_receipt, type: Boolean, desc: Api.heading(:keep_receipt)
      optional :scheduled_for, type: DateTime, desc: Api.heading(:scheduled_for)
      optional :delay, type: String, desc: Api.heading(:delay)
      optional :target_ids, type: Array, desc: Api.heading(:target_ids)

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "scaffolding/absolutely_abstract/creative_concepts", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyAction
    end

    #
    # INDEX
    #

    desc Api.title(:index), &Api.index_desc
    params do
      use :absolutely_abstract_creative_concept_id
    end
    oauth2
    paginate per_page: 100
    get "/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/targets_many_actions" do
      @paginated_targets_many_actions = paginate @targets_many_actions
      render @paginated_targets_many_actions, serializer: Api.serializer
    end

    #
    # CREATE
    #

    desc Api.title(:create), &Api.create_desc
    params do
      use :absolutely_abstract_creative_concept_id
      use :targets_many_action
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/targets_many_actions" do
      if @targets_many_action.save
        render @targets_many_action, serializer: Api.serializer
      else
        record_not_saved @targets_many_action
      end
    end
  end

  resource "scaffolding/completely_concrete/tangible_things/targets_many_actions", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyAction
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
        render @targets_many_action, serializer: Api.serializer
      end
    end

    #
    # UPDATE
    #

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :targets_many_action
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @targets_many_action.update(declared(params, include_missing: false))
          render @targets_many_action, serializer: Api.serializer
        else
          record_not_saved @targets_many_action
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
        render @targets_many_action.destroy, serializer: Api.serializer
      end
    end
  end
end
