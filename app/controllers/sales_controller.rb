class SalesController < ApplicationController
  # Usamos set_sale solo en las acciones que realmente requieren un ID
  before_action :set_sale, only: %i[show edit update destroy]

  # GET /sales
  def index
    if params[:nombre].present?
      # Buscamos las ventas por el nombre del paciente o por servicio
      @sales = Sale.joins(:paciente)
                   .where("pacientes.nombre LIKE ? OR pacientes.apellido_paterno LIKE ? OR sales.servicio LIKE ?", "%#{params[:nombre]}%", "%#{params[:nombre]}%", "%#{params[:nombre]}%")
    else
      @sales = Sale.all
    end
    
    # Agrupar las ventas por mes y año
    @grouped_sales = @sales.group_by { |sale| sale.created_at.strftime("%Y-%m") }
    
    # Calcula la suma total de los costos
    @total_costo = @sales.sum(:costo)
  end

  # GET /sales/1
  def show
  end

  # GET /sales/new
  def new
    @sale = Sale.new
  end

  # POST /sales
  def create
    @sale = Sale.new(sale_params)
    if @sale.save
      redirect_to @sale, notice: "Sale was successfully created."
    else
      render :new
    end
  end

  # GET /sales/1/edit
  def edit
  end

  # PATCH/PUT /sales/1
  def update
    if @sale.update(sale_params)
      redirect_to @sale, notice: "Sale was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /sales/1
  def destroy
    @sale.destroy
    redirect_to sales_url, notice: "Sale was successfully destroyed."
  end

  # GET /sales/form
  def form
    # No se ejecuta set_sale aquí, ya que no necesitamos un `id` para esta acción
    @sales = Sale.all
    @total_costo = @sales.sum(:costo) # Calcula la suma total de los costos
  end

  private

    # Solo ejecutamos set_sale en las acciones que requieren un ID.
    def set_sale
      # Solo se ejecuta si hay un `id` en los parámetros
      if params[:id].present?
        @sale = Sale.find(params[:id])
      end
    end

    # Solo permitimos una lista de parámetros confiables.
    def sale_params
      params.require(:sale).permit(:costo, :servicio, :paciente_id)
    end
end
