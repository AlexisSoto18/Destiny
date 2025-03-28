class PacientesController < ApplicationController
  before_action :set_paciente, only: [ :show, :edit, :update, :destroy ]
  def index
    # @pacientes = Paciente.all
    if params[:nombre].present?
      # Busca pacientes cuyo nombre coincida parcialmente
      @pacientes = Paciente.search(params[:nombre])
    else
      # Muestra todos los pacientes si no se busca nada
      @pacientes = Paciente.all
    end
  end
   # GET /pacientes/:id
   def show
   end

   # GET /pacientes/new
   def new
     @paciente = Paciente.new
     @paciente.build_direccion
   end

   # POST /pacientes
   def create
     @paciente = Paciente.new(paciente_params.merge(user_id: Current.session.user_id))
     # byebug
     if @paciente.save!
       redirect_to @paciente, notice: "Paciente creado exitosamente."
     else
      puts @paciente.errors.full_messages
       render :new
     end
   end

   # GET /pacientes/:id/edit
   def edit
    @paciente.build_direccion if @paciente.direccion.nil?
   end

   # PATCH/PUT /pacientes/:id
   def update
     if @paciente.update(paciente_params)
       redirect_to @paciente, notice: "Paciente actualizado exitosamente."
     else
       render :edit
     end
   end

   # DELETE /pacientes/:id
   def destroy
     @paciente.destroy
     redirect_to pacientes_url, notice: "Paciente eliminado exitosamente."
   end

   private

   # Método para encontrar el paciente por ID
   def set_paciente
    # @paciente = Paciente.new(paciente_params.merge(user_id: User.last.id))
    @paciente = Paciente.find(params[:id])
   end

   # Permitir solo parámetros seguros
   def paciente_params
     params.require(:paciente).permit(
      :curp, :nombre, :apellido_paterno, :apellido_materno, :nivel_socioeconomico, :tipo_sanguineo, :discapacidad, :grupo_etnico, :religion,
      direccion_attributes: [ :id, :correo_electronico, :telefono_emergencia, :telefono_principal, :estado, :municipio, :localidad, :calle, :code_postal, :_destroy ],
        # historial_clinico_attributes: [ :id, :medico, :historial_clinico, :acciones_tomadas, :riesgos_identificados, :_destroy ]
        # sales_attributes: [ :id, :costo, :servicio, :_destroy ],
        # schedules_attributes: [ :id, :titulo, :descripcion, :fecha_hora, :_destroy ]
      )
   end
end
