class Account::Scaffolding::CompletelyConcrete::TangibleThings::PerformsExportActionsController < Account::ApplicationController
  account_load_and_authorize_resource :performs_export_action, through: :absolutely_abstract_creative_concept, through_association: :completely_concrete_tangible_things_performs_export_actions, member_actions: [:approve]

  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/performs_export_actions
  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/performs_export_actions.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    redirect_to [:account, @absolutely_abstract_creative_concept]
  end

  # GET /account/scaffolding/completely_concrete/tangible_things/performs_export_actions/:id
  # GET /account/scaffolding/completely_concrete/tangible_things/performs_export_actions/:id.json
  def show
  end

  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/performs_export_actions/new
  def new
  end

  # GET /account/scaffolding/completely_concrete/tangible_things/performs_export_actions/:id/edit
  def edit
  end

  # POST /account/scaffolding/completely_concrete/tangible_things/performs_export_actions/:id/approve
  def approve
    respond_to do |format|
      if @performs_export_action.approve_by(current_membership)
        format.html { redirect_to [:account, @absolutely_abstract_creative_concept], notice: I18n.t("scaffolding/completely_concrete/tangible_things/performs_export_actions.notifications.approved") }
        format.json { render :show, status: :ok, location: [:account, @performs_export_action] }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @performs_export_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/performs_export_actions
  # POST /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/performs_export_actions.json
  def create
    respond_to do |format|
      # TODO We should probably employ Current Attributes in Rails and set this in the model, so the same thing is
      # happening automatically when we create an action via the API endpoint as well.
      @performs_export_action.created_by = current_membership

      if @performs_export_action.save
        format.html { redirect_to [:account, @performs_export_action], notice: I18n.t("scaffolding/completely_concrete/tangible_things/performs_export_actions.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @performs_export_action] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @performs_export_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/scaffolding/completely_concrete/tangible_things/performs_export_actions/:id
  # PATCH/PUT /account/scaffolding/completely_concrete/tangible_things/performs_export_actions/:id.json
  def update
    respond_to do |format|
      if @performs_export_action.update(performs_export_action_params)
        format.html { redirect_to [:account, @performs_export_action], notice: I18n.t("scaffolding/completely_concrete/tangible_things/performs_export_actions.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @performs_export_action] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @performs_export_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/scaffolding/completely_concrete/tangible_things/performs_export_actions/:id
  # DELETE /account/scaffolding/completely_concrete/tangible_things/performs_export_actions/:id.json
  def destroy
    @performs_export_action.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things_performs_export_actions], notice: I18n.t("scaffolding/completely_concrete/tangible_things/performs_export_actions.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def performs_export_action_params
    strong_params = params.require(:scaffolding_completely_concrete_tangible_things_performs_export_action).permit(
      :target_all,
      :scheduled_for,
      # 🚅 super scaffolding will insert new fields above this line.
      target_ids: [],
      fields: [],
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    # 🚅 super scaffolding will insert processing for new fields above this line.

    assign_boolean(strong_params, :target_all)
    assign_select_options(strong_params, :target_ids)
    assign_date_and_time(strong_params, :scheduled_for)
    assign_checkboxes(strong_params, :fields)

    strong_params
  end
end
