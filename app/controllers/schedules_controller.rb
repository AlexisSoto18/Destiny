class SchedulesController < ApplicationController
  before_action :set_schedule, only: [ :show, :edit, :update, :destroy ]

  def index
    @schedules = Schedule.all
  end
  def show
  end
  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.new(schedule_params)
    if @schedule.save
      redirect_to schedules_path, notice: "Cita agendada con éxito."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @schedule.update(sale_params)
      redirect_to @schedule, notice: "Sale was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @schedule.destroy
    redirect_to schedules_url, notice: "Cita eliminada con éxito."
  end

  private

  def set_schedule
    if params[:id].present?
      @schedule = Schedule.find(params[:id])
    end
  end

  def schedule_params
    params.require(:schedule).permit(:titulo, :descripcion, :fecha_hora, :paciente_id)
  end
end
