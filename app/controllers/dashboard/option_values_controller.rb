class Dashboard::OptionValuesController < DashboardController
  before_action :set_option_type

  def create
    @option_value = @option_type.option_values.build(option_value_params)
    if @option_value.save
      respond_to do |format|
        format.turbo_stream
      end 
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_option_value_form_#{@option_type.id}",
            partial: "dashboard/option_values/form",
            locals: { option_type: @option_type, option_value: @option_value }
          )
        end
      end
    end
  end

  def destroy
    @option_value = @option_type.option_values.find(params[:id])
    @option_value.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("option_value_#{@option_value.id}")
      end
    end
  end

  private

  def set_option_type
    @option_type = OptionType.find(params[:option_type_id])
  end

  def option_value_params
    params.require(:option_value).permit(:name)
  end
end