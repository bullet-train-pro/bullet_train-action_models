class Api::V1::Scaffolding::CompletelyConcrete::TangibleThings::PerformsExportActionsEndpoint < Api::V1::Root
  helpers do
    params :absolutely_abstract_creative_concept_id do
      requires :absolutely_abstract_creative_concept_id, type: Integer, allow_blank: false, desc: "Creative Concept ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Targets Many Action ID"
    end

    params :performs_export_action do
      # 🚅 skip this section when scaffolding.
      # 🚅 stop any skipping we're doing now.
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      optional :target_all, type: Boolean, desc: Api.heading(:target_all)
      optional :scheduled_for, type: DateTime, desc: Api.heading(:scheduled_for)
      optional :target_ids, type: Array, desc: Api.heading(:target_ids)

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "scaffolding/absolutely_abstract/creative_concepts", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource Scaffolding::CompletelyConcrete::TangibleThings::PerformsExportAction
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
    get "/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/performs_export_actions" do
      @paginated_performs_export_actions = paginate @performs_export_actions
      render @paginated_performs_export_actions, serializer: Api.serializer
    end

    #
    # CREATE
    #

    desc Api.title(:create), &Api.create_desc
    params do
      use :absolutely_abstract_creative_concept_id
      use :performs_export_action
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/performs_export_actions" do
      if @performs_export_action.save
        render @performs_export_action, serializer: Api.serializer
      else
        record_not_saved @performs_export_action
      end
    end
  end

  resource "scaffolding/completely_concrete/tangible_things/performs_export_actions", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource Scaffolding::CompletelyConcrete::TangibleThings::PerformsExportAction
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
        render @performs_export_action, serializer: Api.serializer
      end
    end

    #
    # UPDATE
    #

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :performs_export_action
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @performs_export_action.update(declared(params, include_missing: false))
          render @performs_export_action, serializer: Api.serializer
        else
          record_not_saved @performs_export_action
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
        render @performs_export_action.destroy, serializer: Api.serializer
      end
    end
  end
end
