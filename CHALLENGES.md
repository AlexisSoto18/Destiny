# 🧪 Prueba Técnica — Junior Support Engineer (Ruby on Rails)

> La aplicación **Destiny** está en producción y los usuarios están reportando bugs.
> Tu misión: **diagnosticar y corregir cada problema** como lo haría un ingeniero de soporte.
>
> Cada challenge está en su propia rama. Cámbiate a la rama, reproduce el error,
> identifica la causa raíz y corrígela. Habla en voz alta mientras trabajas.

---

## Cómo usar estos challenges

```bash
# Ver todas las ramas disponibles
git branch

# Cambiar a un challenge
git checkout challenge/1-routing-error

# Cuando termines, volver a main para el siguiente
git checkout main
```

---

## Challenge 1 — RoutingError: "Los pacientes desaparecieron"

**Rama:** `challenge/1-routing-error`

**Reporte del usuario:**
> "Oye, entro a `/pacientes` y me sale un error blanco. Antes funcionaba perfecto."

**Tu tarea:**
1. Cambia a la rama e inicia el servidor: `rails s`
2. Navega a `http://localhost:3000/pacientes`
3. Lee el error en la terminal del servidor
4. Encuentra **en qué archivo está el problema** y corrígelo
5. Verifica que `/pacientes`, `/pacientes/new` y `/pacientes/:id/medical_records` vuelvan a funcionar

**Pistas (solo si te trabas):**
<details>
<summary>Pista 1</summary>
El error dice `ActionController::RoutingError`. ¿Qué archivo define las rutas en Rails?
</details>
<details>
<summary>Pista 2</summary>
Busca en `config/routes.rb` si el recurso `:pacientes` está declarado correctamente.
</details>
<details>
<summary>Solución</summary>

En `config/routes.rb` las líneas `resources :pacientes do / resources :medical_records / end`
están comentadas. Descoméntalas.

```ruby
resources :pacientes do
  resources :medical_records
end
```
</details>

---

## Challenge 2 — Strong Parameters: "Los pacientes no tienen nombre"

**Rama:** `challenge/2-missing-params`

**Reporte del usuario:**
> "Creé tres pacientes nuevos y todos quedan sin nombre ni apellidos en la lista. El formulario sí los tiene."

**Tu tarea:**
1. Cambia a la rama e inicia el servidor
2. Ve a `/pacientes/new` y crea un paciente con nombre completo
3. Observa el resultado en la tabla de pacientes
4. Encuentra por qué los campos de nombre **no se guardan** en la base de datos
5. Corrígelo sin modificar el formulario ni la vista

**Pistas:**
<details>
<summary>Pista 1</summary>
El formulario envía los datos, pero el controlador los "filtra". ¿Dónde hace eso Rails?
</details>
<details>
<summary>Pista 2</summary>
Busca el método `paciente_params` en `app/controllers/pacientes_controller.rb`.
Compara los campos en el `permit(...)` con los campos del formulario.
</details>
<details>
<summary>Solución</summary>

En `PacientesController#paciente_params`, faltan `:nombre`, `:apellido_paterno` y `:apellido_materno`
en la lista de parámetros permitidos. Agrégalos:

```ruby
params.require(:paciente).permit(
  :curp, :nombre, :apellido_paterno, :apellido_materno,
  :nivel_socioeconomico, :tipo_sanguineo, :discapacidad, :grupo_etnico, :religion,
  direccion_attributes: [...]
)
```
</details>

---

## Challenge 3 — N+1 Queries: "La app está lentísima"

**Rama:** `challenge/3-n-plus-one`

**Reporte del usuario:**
> "La página de agenda tarda siglos en cargar cuando hay muchas citas. Lo mismo con ventas."

**Tu tarea:**
1. Cambia a la rama e inicia el servidor con los logs visibles
2. Ve a `/schedules` y observa la terminal del servidor
3. Cuenta cuántas consultas SQL se generan para cargar la lista de citas
4. Identifica el patrón de consultas repetidas (el infame **N+1**)
5. Corrige el problema en `schedules_controller.rb` **y** en `sales_controller.rb`

**Conceptos clave:**
- Una consulta N+1 ocurre cuando Rails hace 1 consulta para cargar los registros
  y luego N consultas adicionales (una por registro) para cargar una asociación
- La solución siempre involucra **eager loading** con `.includes(:asociacion)`

**Pistas:**
<details>
<summary>Pista 1</summary>
En los logs verás repetido algo como:
`SELECT * FROM "pacientes" WHERE "pacientes"."id" = ?`
una vez por cada cita. Eso es N+1.
</details>
<details>
<summary>Pista 2</summary>
En `schedules_controller.rb` la consulta perdió su `.includes(:paciente)`.
En `sales_controller.rb` el índice ahora itera con Ruby en lugar de SQL.
</details>
<details>
<summary>Solución</summary>

**schedules_controller.rb:**
```ruby
@schedules = Schedule.where(fecha_hora: ...).includes(:paciente)
```

**sales_controller.rb** (cuando hay búsqueda):
```ruby
@sales = Sale.joins(:paciente)
             .where("pacientes.nombre LIKE ? OR ...", "%#{params[:nombre]}%", ...)
```
</details>

---

## Challenge 4 — NoMethodError: "El historial clínico explota"

**Rama:** `challenge/4-broken-association`

**Reporte del usuario:**
> "Entro al perfil de un paciente, hago click en 'Ver historial' y me sale un error 500."

**Tu tarea:**
1. Cambia a la rama e inicia el servidor
2. Ve a `/pacientes`, selecciona cualquier paciente, y navega a su historial clínico
3. Lee el error completo en la terminal: ¿qué método no existe? ¿en qué objeto?
4. Encuentra dónde está definida (o mal definida) esa asociación
5. Corrígela

**Pistas:**
<details>
<summary>Pista 1</summary>
El error es `NoMethodError: undefined method 'historial_clinicos' for #<Paciente...>`.
Eso significa que el modelo `Paciente` no tiene ese método. ¿Por qué?
</details>
<details>
<summary>Pista 2</summary>
Abre `app/models/paciente.rb` y mira el nombre exacto del `has_many`.
Compáralo con lo que el controlador llama: `@paciente.historial_clinicos`.
</details>
<details>
<summary>Solución</summary>

En `app/models/paciente.rb`:
```ruby
# ❌ Incorrecto (singular)
has_many :historial_clinico, dependent: :destroy

# ✅ Correcto (plural)
has_many :historial_clinicos, dependent: :destroy
```
</details>

---

## Challenge 5 — Nil Reference: "Ver una venta tira error 500"

**Rama:** `challenge/5-nil-crash`

**Reporte del usuario:**
> "Antes podía ver el detalle de una venta. Ahora al hacer click me sale un error horrible."

**Tu tarea:**
1. Cambia a la rama e inicia el servidor
2. Ve a `/sales`, haz click en cualquier venta para ver su detalle
3. Lee el error: ¿qué variable es `nil`? ¿en qué línea del controlador o vista?
4. Traza el flujo: Ruta → `before_action` → `set_sale` → `show`
5. Encuentra por qué `@sale` llega como `nil` y corrígelo

**Pistas:**
<details>
<summary>Pista 1</summary>
El error es `NoMethodError: undefined method 'costo' for nil`.
`@sale` es `nil`. ¿Quién asigna `@sale`?
</details>
<details>
<summary>Pista 2</summary>
Mira el método privado `set_sale` en `SalesController`.
¿Está buscando el registro por la columna correcta?
`Sale.find_by(servicio: params[:id])` busca por el campo `servicio`
usando el `id` numérico de la URL. Eso casi nunca coincide → retorna `nil`.
</details>
<details>
<summary>Solución</summary>

En `SalesController#set_sale`:
```ruby
# ❌ Incorrecto
@sale = Sale.find_by(servicio: params[:id])

# ✅ Correcto
@sale = Sale.find(params[:id])
```
</details>

---

## Tabla resumen

| # | Rama | Error visible | Archivo a corregir | Concepto |
|---|------|--------------|-------------------|---------|
| 1 | `challenge/1-routing-error` | `ActionController::RoutingError` | `config/routes.rb` | Rutas |
| 2 | `challenge/2-missing-params` | Datos no se guardan (silencioso) | `app/controllers/pacientes_controller.rb` | Strong Parameters |
| 3 | `challenge/3-n-plus-one` | App lenta, logs con consultas repetidas | `schedules_controller.rb`, `sales_controller.rb` | N+1 / Eager Loading |
| 4 | `challenge/4-broken-association` | `NoMethodError` en historial clínico | `app/models/paciente.rb` | Asociaciones ActiveRecord |
| 5 | `challenge/5-nil-crash` | `NoMethodError: for nil` al ver venta | `app/controllers/sales_controller.rb` | Nil reference / find vs find_by |

---

> **Tip de entrevista:** Antes de tocar código, di en voz alta:
> *"Voy a reproducir el error primero, luego leer el stack trace completo para identificar
> el archivo y la línea, y finalmente buscar la causa raíz antes de escribir cualquier fix."*
> Eso vale más que resolver el bug en 30 segundos sin explicar nada.
