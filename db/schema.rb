# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_17_023048) do
  create_table "direccions", force: :cascade do |t|
    t.string "correo_electronico"
    t.string "telefono_emergencia"
    t.string "telefono_principal"
    t.string "estado"
    t.string "municipio"
    t.string "localidad"
    t.string "calle"
    t.string "code_postal"
    t.integer "paciente_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["paciente_id"], name: "index_direccions_on_paciente_id"
  end

  create_table "historial_clinicos", force: :cascade do |t|
    t.string "medico"
    t.text "historial_clinico"
    t.text "acciones_tomadas"
    t.text "riesgos_identificados"
    t.integer "paciente_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["paciente_id"], name: "index_historial_clinicos_on_paciente_id"
  end

  create_table "pacientes", force: :cascade do |t|
    t.string "nombre"
    t.string "apellido_paterno"
    t.string "apellido_materno"
    t.string "curp"
    t.string "nivel_socioeconomico"
    t.string "tipo_sanguineo"
    t.string "discapacidad"
    t.string "grupo_etnico"
    t.string "religion"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_pacientes_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["password_reset_token"], name: "index_users_on_password_reset_token", unique: true
  end

  add_foreign_key "direccions", "pacientes"
  add_foreign_key "historial_clinicos", "pacientes"
  add_foreign_key "pacientes", "users"
  add_foreign_key "sessions", "users"
end
