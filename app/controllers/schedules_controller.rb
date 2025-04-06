class SchedulesController < ApplicationController
  before_action :set_schedule, only: [ :show, :edit, :update, :destroy ]

  def index
    # @schedules = Schedule.all
    week_offset = params[:week_offset].to_i
    month_offset = params[:month_offset].to_i

    if params[:view] == "month"
      start_date = Date.today.beginning_of_month + month_offset.months
      end_date = start_date.end_of_month
    else
      start_date = Date.today.beginning_of_week(:monday) + week_offset.weeks
      end_date = start_date + 6.days
    end

    @view_mode = params[:view] || "week"
    @start_date = start_date
    @end_date = end_date

    @schedules = Schedule.where(fecha_hora: start_date.beginning_of_day..end_date.end_of_day).includes(:paciente)
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
      if @schedule.errors[:fecha_hora].include?("Ya existe una cita en esta fecha y hora")
        redirect_to @schedules, notice: "Error al crear la cita."
      end
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @schedule.update(schedule_params)
      redirect_to schedules_path, notice: "Sale was successfully updated."
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
