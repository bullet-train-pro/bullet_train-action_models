class Api::V1::Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneActionsController < Api::V1::ApplicationController
  account_load_and_authorize_resource :targets_one_action, through: :tangible_thing, through_association: :targets_one_actions

  # GET /api/v1/scaffolding/completely_concrete/tangible_things/:tangible_thing_id/targets_one_actions
  def index
  end

  # GET /api/v1/scaffolding/completely_concrete/tangible_things/targets_one_actions/:id
  def show
  end

  # POST /api/v1/scaffolding/completely_concrete/tangible_things/:tangible_thing_id/targets_one_actions
  # POST /api/v1/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/targets_one_action
  def create
    if @targets_one_action.save
      render :show, status: :created, location: [:api, :v1, @targets_one_action]
    else
      render json: @targets_one_action.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/scaffolding/completely_concrete/tangible_things/targets_one_actions/:id
  def update
    if @targets_one_action.update(targets_one_action_params)
      render :show
    else
      render json: @targets_one_action.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/scaffolding/completely_concrete/tangible_things/targets_one_actions/:id
  def destroy
    @targets_one_action.destroy
  end

  private

  module StrongParameters
    # Only allow a list of trusted parameters through.
    def targets_one_action_params
      strong_params = params.require(:scaffolding_completely_concrete_tangible_things_targets_one_action).permit(
        *permitted_fields,
        :target_count,
        :performed_count,
        :created_by,
        :approved_by,
        :scheduled_for,
        :started_at,
        :completed_at,
        # 🚅 super scaffolding will insert new fields above this line.
        *permitted_arrays,
        # 🚅 super scaffolding will insert new arrays above this line.
      )

      process_params(strong_params)

      strong_params
    end
  end

  include StrongParameters
end
