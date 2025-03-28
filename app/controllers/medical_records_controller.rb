class MedicalRecordsController < ApplicationController
  before_action :set_paciente
  before_action :set_medical_record, only: [ :edit, :update, :destroy ]
  def new
    @historial_clinico = @paciente.historial_clinicos.new
  end

  def create
    @historial_clinico = @paciente.historial_clinicos.new(medical_record_params)
    if @historial_clinico.save
      redirect_to @paciente, notice: "Historial clínico agregado exitosamente."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @historial_clinico.update(medical_record_params)
      redirect_to @paciente, notice: "Historial clínico actualizado exitosamente."
    else
      render :edit
    end
  end

  def destroy
    @historial_clinico.destroy
    redirect_to @paciente, notice: "Historial clínico eliminado exitosamente."
  end

  private

  def set_paciente
    @paciente = Paciente.find(params[:paciente_id])
  end

  def set_medical_record
    @historial_clinico = @paciente.historial_clinicos.find(params[:id])
  end

  def medical_record_params
    params.require(:historial_clinico).permit(:medico, :historial_clinico, :acciones_tomadas, :riesgos_identificados)
  end
end
