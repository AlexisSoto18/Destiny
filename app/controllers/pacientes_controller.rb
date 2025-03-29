class PacientesController < ApplicationController
  before_action :set_paciente, only: [:show, :edit, :update, :destroy]

  def index
    if params[:nombre].present?
      @pacientes = Paciente.search(params[:nombre])
    else
      @pacientes = Paciente.all
    end
  end

  def show
  end

  def new
    @paciente = Paciente.new
    @paciente.build_direccion
  end

  def create
    @paciente = Paciente.new(paciente_params.merge(user_id: Current.session.user_id))
    if @paciente.save
      redirect_to @paciente, notice: "Paciente creado exitosamente."
    else
      puts @paciente.errors.full_messages
      render :new
    end
  end

  def edit
    @paciente.build_direccion if @paciente.direccion.nil?
  end

  def update
    if @paciente.update(paciente_params)
      redirect_to @paciente, notice: "Paciente actualizado exitosamente."
    else
      render :edit
    end
  end

  def destroy
    @paciente.destroy
    redirect_to pacientes_url, notice: "Paciente eliminado exitosamente."
  end

  private

  def set_paciente
    @paciente = Paciente.find_by(id: params[:id])
    unless @paciente
      redirect_to pacientes_path, alert: "Paciente no encontrado."
    end
  end

  def paciente_params
    params.require(:paciente).permit(
      :curp, :nombre, :apellido_paterno, :apellido_materno, :nivel_socioeconomico, :tipo_sanguineo, :discapacidad, :grupo_etnico, :religion,

      direccion_attributes: [ :id, :correo_electronico, :telefono_emergencia, :telefono_principal, :estado, :municipio, :localidad, :calle, :code_postal, :_destroy ],
        # historial_clinico_attributes: [ :id, :medico, :historial_clinico, :acciones_tomadas, :riesgos_identificados, :_destroy ]
        # sales_attributes: [ :id, :costo, :servicio, :_destroy ],
        # schedules_attributes: [ :id, :titulo, :descripcion, :fecha_hora, :_destroy ]
      )
   end
