class Admin::Qualiopi::IndicatorsController < Admin::ApplicationController
  load_and_authorize_resource class: Qualiopi::Indicator

  def index
    breadcrumb
  end

  def show
    @programs = Program.all
    @checks = [
      :prerequisites,
      :objectives,
      :duration,
      :pricing,
      :registration,
      :pedagogy,
      :evaluation,
      :accessibility
    ]
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb 'Modifier'
  end

  def create
    respond_to do |format|
      if @indicator.save
        format.html { redirect_to [:admin, @indicator], notice: "Indicator was successfully created." }
        format.json { render :show, status: :created, location: [:admin, @indicator] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @indicator.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @indicator.update(indicator_params)
        format.html { redirect_to [:admin, @indicator], notice: "Indicator was successfully updated." }
        format.json { render :show, status: :ok, location: [:admin, @indicator] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: [:admin, @indicator].errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @indicator.destroy
    respond_to do |format|
      format.html { redirect_to admin_qualiopi_indicators_url, notice: "Indicator was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Qualiopi.model_name.human(count: 2), admin_qualiopi_root_path
    if @indicator
      add_breadcrumb @indicator.criterion, [:admin, @indicator.criterion]
      if @indicator.persisted?
        add_breadcrumb @indicator, [:admin, @indicator]
      else
        add_breadcrumb 'Créer'
      end
    end
  end

  def indicator_params
    params.require(:qualiopi_indicator).permit(:criterion_id, :number, :name, :level_expected, :proof, :requirement, :non_conformity)
  end
end
