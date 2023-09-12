class Account::Scaffolding::CompletelyConcrete::TangibleThings::PerformsImportActionsController < Account::ApplicationController
  include Actions::ControllerSupport

  account_load_and_authorize_resource :performs_import_action, through: :absolutely_abstract_creative_concept, through_association: :completely_concrete_tangible_things_performs_import_actions, member_actions: [:approve]

  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/performs_import_actions
  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/performs_import_actions.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    redirect_to [:account, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things]
  end

  # GET /account/scaffolding/completely_concrete/tangible_things/performs_import_actions/:id
  # GET /account/scaffolding/completely_concrete/tangible_things/performs_import_actions/:id.json
  def show
  end

  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/performs_import_actions/new
  def new
  end

  # GET /account/scaffolding/completely_concrete/tangible_things/performs_import_actions/:id/edit
  def edit
  end

  # POST /account/scaffolding/completely_concrete/tangible_things/performs_import_actions/:id/approve
  def approve
    respond_to do |format|
      if @performs_import_action.approve_by(current_membership)
        format.html { redirect_to [:account, @performs_import_action], notice: I18n.t("scaffolding/completely_concrete/tangible_things/performs_import_actions.notifications.approved") }
        format.json { render :show, status: :ok, location: [:account, @performs_import_action] }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @performs_import_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/performs_import_actions
  # POST /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/performs_import_actions.json
  def create
    respond_to do |format|
      # TODO We should probably employ Current Attributes in Rails and set this in the model, so the same thing is
      # happening automatically when we create an action via the API endpoint as well.
      @performs_import_action.created_by = current_membership

      if @performs_import_action.save
        format.html { redirect_to [:edit, :account, @performs_import_action], notice: I18n.t("scaffolding/completely_concrete/tangible_things/performs_import_actions.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @performs_import_action] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @performs_import_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/scaffolding/completely_concrete/tangible_things/performs_import_actions/:id
  # PATCH/PUT /account/scaffolding/completely_concrete/tangible_things/performs_import_actions/:id.json
  def update
    populate_mappings(params["scaffolding_completely_concrete_tangible_things_csv_import_action"])

    respond_to do |format|
      if @performs_import_action.update(performs_import_action_params)
        format.html { redirect_to [:account, @performs_import_action], notice: I18n.t("scaffolding/completely_concrete/tangible_things/performs_import_actions.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @performs_import_action] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @performs_import_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/scaffolding/completely_concrete/tangible_things/performs_import_actions/:id
  # DELETE /account/scaffolding/completely_concrete/tangible_things/performs_import_actions/:id.json
  def destroy
    @performs_import_action.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things_performs_import_actions], notice: I18n.t("scaffolding/completely_concrete/tangible_things/performs_import_actions.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def performs_import_action_params
    strong_params = params.require(:scaffolding_completely_concrete_tangible_things_performs_import_action).permit(
      :file,
      :copy_mapping_from_id,
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    if @import_action&.persisted?
      assign_mapping(strong_params, @performs_import_action, :mapping)
    end

    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end

  # We suggest mappings for the developer with OpenAI,
  # but we ultimately want to use the mappings they chose with the select input.
  def populate_mappings(mappings)
    mappings.each do |mapping|
      attribute = mapping.first.gsub(/^mapping_/, "")
      @csv_import_action.mapping[attribute] = mapping.last.empty? ? nil : mapping.last
    end
  end
end
