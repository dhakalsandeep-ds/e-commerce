class Dashboard::OptionTypesController < DashboardController
  before_action :set_option_type, only: [:destroy]

  def index
    @option_types = OptionType.includes(:option_values).order(:name)
    @option_type = OptionType.new
  end

  def create
    @option_type = OptionType.new(option_type_params)
    if @option_type.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_option_type_form",
            partial: "dashboard/option_types/form",
            locals: { option_type: @option_type }
          )
        end
      end
    end
  end

  def destroy
    @option_type = OptionType.find(params[:id])
    @option_type.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("option_type_#{@option_type.id}")
      end
    end
  end

  private

  def set_option_type
    @option_type = OptionType.find(params[:id])
  end

  def option_type_params
    params.require(:option_type).permit(:name)
  end
end