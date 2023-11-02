class Account::Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneParentActionsController < Account::ApplicationController
  account_load_and_authorize_resource :targets_one_parent_action, through: :absolutely_abstract_creative_concept, through_association: :completely_concrete_tangible_things_targets_one_parent_actions, member_actions: [:approve]

  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/targets_one_parent_actions
  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/targets_one_parent_actions.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    redirect_to [:account, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things]
  end

  # GET /account/scaffolding/completely_concrete/tangible_things/targets_one_parent_actions/:id
  # GET /account/scaffolding/completely_concrete/tangible_things/targets_one_parent_actions/:id.json
  def show
  end

  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/targets_one_parent_actions/new
  def new
  end

  # GET /account/scaffolding/completely_concrete/tangible_things/targets_one_parent_actions/:id/edit
  def edit
  end

  # POST /account/scaffolding/completely_concrete/tangible_things/targets_one_parent_actions/:id/approve
  def approve
    respond_to do |format|
      if @targets_one_parent_action.approve_by(current_membership)
        format.html { redirect_to [:account, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things], notice: I18n.t("scaffolding/completely_concrete/tangible_things/targets_one_parent_actions.notifications.approved") }
        format.json { render :show, status: :ok, location: helpers.build_action_model_path(@targets_one_parent_action) }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @targets_one_parent_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/targets_one_parent_actions
  # POST /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/targets_one_parent_actions.json
  def create
    respond_to do |format|
      # TODO We should probably employ Current Attributes in Rails and set this in the model, so the same thing is
      # happening automatically when we create an action via the API endpoint as well.
      @targets_one_parent_action.created_by = current_membership

      if @targets_one_parent_action.save
        format.html { redirect_to [:account, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things_targets_one_parent_actions], notice: I18n.t("scaffolding/completely_concrete/tangible_things/targets_one_parent_actions.notifications.created") }
        format.json { render :show, status: :created, location: helpers.build_action_model_path(@targets_one_parent_action) }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @targets_one_parent_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/scaffolding/completely_concrete/tangible_things/targets_one_parent_actions/:id
  # PATCH/PUT /account/scaffolding/completely_concrete/tangible_things/targets_one_parent_actions/:id.json
  def update
    respond_to do |format|
      if @targets_one_parent_action.update(targets_one_parent_action_params)
        format.html { redirect_to helpers.build_action_model_path(@targets_one_parent_action), notice: I18n.t("scaffolding/completely_concrete/tangible_things/targets_one_parent_actions.notifications.updated") }
        format.json { render :show, status: :ok, location: helpers.build_action_model_path(@targets_one_parent_action) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @targets_one_parent_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/scaffolding/completely_concrete/tangible_things/targets_one_parent_actions/:id
  # DELETE /account/scaffolding/completely_concrete/tangible_things/targets_one_parent_actions/:id.json
  def destroy
    @targets_one_parent_action.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things_targets_one_parent_actions], notice: I18n.t("scaffolding/completely_concrete/tangible_things/targets_one_parent_actions.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def targets_one_parent_action_params
    strong_params = params.require(:scaffolding_completely_concrete_tangible_things_targets_one_parent_action).permit(
      :target_all,
      :scheduled_for,
      :delay,
      # 🚅 super scaffolding will insert new fields above this line.
      target_ids: [],
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    # 🚅 super scaffolding will insert processing for new fields above this line.

    assign_boolean(strong_params, :target_all)
    assign_select_options(strong_params, :target_ids)
    assign_date_and_time(strong_params, :scheduled_for)

    strong_params
  end
end
