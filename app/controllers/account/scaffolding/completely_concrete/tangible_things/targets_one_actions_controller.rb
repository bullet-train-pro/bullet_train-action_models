class Account::Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneActionsController < Account::ApplicationController
  account_load_and_authorize_resource :targets_one_action, through: :tangible_thing, through_association: :targets_one_actions, member_actions: [:approve]

  # GET /account/scaffolding/completely_concrete/tangible_things/:tangible_thing_id/targets_one_actions
  # GET /account/scaffolding/completely_concrete/tangible_things/:tangible_thing_id/targets_one_actions.json
  def index
    redirect_to [:account, @tangible_thing]
  end

  # GET /account/scaffolding/completely_concrete/tangible_things/targets_one_actions/:id
  # GET /account/scaffolding/completely_concrete/tangible_things/targets_one_actions/:id.json
  def show
  end

  # GET /account/scaffolding/completely_concrete/tangible_things/:tangible_thing_id/targets_one_actions/new
  def new
  end

  # GET /account/scaffolding/completely_concrete/tangible_things/targets_one_actions/:id/edit
  def edit
  end

  # POST /account/scaffolding/completely_concrete/tangible_things/targets_one_actions/:id/approve
  def approve
    respond_to do |format|
      if @targets_one_action.approve_by(current_membership)
        format.html { redirect_to [:account, @tangible_thing, :targets_one_actions], notice: I18n.t("scaffolding/completely_concrete/tangible_things/targets_one_actions.notifications.approved") }
        format.json { render :show, status: :ok, location: [:account, @targets_one_action] }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @targets_one_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /account/scaffolding/completely_concrete/tangible_things/:tangible_thing_id/targets_one_actions
  # POST /account/scaffolding/completely_concrete/tangible_things/:tangible_thing_id/targets_one_actions.json
  def create
    respond_to do |format|
      # TODO We should probably employ Current Attributes in Rails and set this in the model, so the same thing is
      # happening automatically when we create an action via the API endpoint as well.
      @targets_one_action.created_by = current_membership

      if @targets_one_action.save
        format.html { redirect_to [:account, @tangible_thing, :targets_one_actions], notice: I18n.t("scaffolding/completely_concrete/tangible_things/targets_one_actions.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @targets_one_action] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @targets_one_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/scaffolding/completely_concrete/tangible_things/targets_one_actions/:id
  # PATCH/PUT /account/scaffolding/completely_concrete/tangible_things/targets_one_actions/:id.json
  def update
    respond_to do |format|
      if @targets_one_action.update(targets_one_action_params)
        format.html { redirect_to [:account, @targets_one_action], notice: I18n.t("scaffolding/completely_concrete/tangible_things/targets_one_actions.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @targets_one_action] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @targets_one_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/scaffolding/completely_concrete/tangible_things/targets_one_actions/:id
  # DELETE /account/scaffolding/completely_concrete/tangible_things/targets_one_actions/:id.json
  def destroy
    @targets_one_action.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @tangible_thing, :targets_one_actions], notice: I18n.t("scaffolding/completely_concrete/tangible_things/targets_one_actions.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  include strong_parameters_from_api

  def process_params(strong_params)
    assign_date_and_time(strong_params, :scheduled_for)
    assign_date_and_time(strong_params, :started_at)
    assign_date_and_time(strong_params, :completed_at)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
