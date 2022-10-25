class Account::Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyActionsController < Account::ApplicationController
  account_load_and_authorize_resource :targets_many_action, through: :absolutely_abstract_creative_concept, through_association: :completely_concrete_tangible_things_targets_many_actions, member_actions: [:approve]

  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/targets_many_actions
  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/targets_many_actions.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    redirect_to [:account, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things]
  end

  # GET /account/scaffolding/completely_concrete/tangible_things/targets_many_actions/:id
  # GET /account/scaffolding/completely_concrete/tangible_things/targets_many_actions/:id.json
  def show
  end

  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/targets_many_actions/new
  def new
  end

  # GET /account/scaffolding/completely_concrete/tangible_things/targets_many_actions/:id/edit
  def edit
  end

  # POST /account/scaffolding/completely_concrete/tangible_things/targets_many_actions/:id/approve
  def approve
    respond_to do |format|
      if @targets_many_action.approve_by(current_membership)
        format.html { redirect_to [:account, @absolutely_abstract_creative_concept], notice: I18n.t("scaffolding/completely_concrete/tangible_things/targets_many_actions.notifications.approved") }
        format.json { render :show, status: :ok, location: [:account, @targets_many_action] }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @targets_many_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/targets_many_actions
  # POST /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things/targets_many_actions.json
  def create
    respond_to do |format|
      # TODO We should probably employ Current Attributes in Rails and set this in the model, so the same thing is
      # happening automatically when we create an action via the API endpoint as well.
      @targets_many_action.created_by = current_membership

      if @targets_many_action.save
        format.html { redirect_to [:account, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things_targets_many_actions], notice: I18n.t("scaffolding/completely_concrete/tangible_things/targets_many_actions.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @targets_many_action] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @targets_many_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/scaffolding/completely_concrete/tangible_things/targets_many_actions/:id
  # PATCH/PUT /account/scaffolding/completely_concrete/tangible_things/targets_many_actions/:id.json
  def update
    respond_to do |format|
      if @targets_many_action.update(targets_many_action_params)
        format.html { redirect_to [:account, @targets_many_action], notice: I18n.t("scaffolding/completely_concrete/tangible_things/targets_many_actions.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @targets_many_action] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @targets_many_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/scaffolding/completely_concrete/tangible_things/targets_many_actions/:id
  # DELETE /account/scaffolding/completely_concrete/tangible_things/targets_many_actions/:id.json
  def destroy
    @targets_many_action.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things_targets_many_actions], notice: I18n.t("scaffolding/completely_concrete/tangible_things/targets_many_actions.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  include strong_parameters_from_api

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
