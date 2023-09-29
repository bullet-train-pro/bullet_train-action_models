class Api::V1::Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyActionsController < Api::V1::ApplicationController
  account_load_and_authorize_resource :targets_many_action, through: :absolutely_abstract_creative_concept, through_association: :completely_concrete_tangible_things_targets_many_actions

  # GET /api/v1/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/targets_many_actions
  def index
  end

  # GET /api/v1/scaffolding/completely_concrete/tangible_things/targets_many_actions/:id
  def show
  end

  # POST /api/v1/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/targets_many_actions
  def create
    if @targets_many_action.save
      render :show, status: :created, location: [:api, :v1, @targets_many_action]
    else
      render json: @targets_many_action.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/scaffolding/completely_concrete/tangible_things/targets_many_actions/:id
  def update
    if @targets_many_action.update(targets_many_action_params)
      render :show
    else
      render json: @targets_many_action.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/scaffolding/completely_concrete/tangible_things/targets_many_actions/:id
  def destroy
    @targets_many_action.destroy
  end

  private

  module StrongParameters
    # Only allow a list of trusted parameters through.
    def targets_many_action_params
      strong_params = params.require(:scaffolding_completely_concrete_tangible_things_targets_many_action).permit(
        *permitted_fields,
        :target_all,
        :scheduled_for,
        :created_by,
        :approved_by,
        # 🚅 super scaffolding will insert new fields above this line.
        *permitted_arrays,
        target_ids: [],
        # 🚅 super scaffolding will insert new arrays above this line.
      )

      process_params(strong_params)

      strong_params
    end
  end

  include StrongParameters
end
