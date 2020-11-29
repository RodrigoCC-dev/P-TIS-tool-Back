# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_29_231604) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "asistencias", force: :cascade do |t|
    t.bigint "id_estudiante"
    t.bigint "id_stakeholder"
    t.bigint "minuta_id", null: false
    t.bigint "tipo_asistencia_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["minuta_id"], name: "index_asistencias_on_minuta_id"
    t.index ["tipo_asistencia_id"], name: "index_asistencias_on_tipo_asistencia_id"
  end

  create_table "bitacora_estados", force: :cascade do |t|
    t.boolean "activo", default: true
    t.boolean "revisado", default: false
    t.bigint "minuta_id", null: false
    t.bigint "tipo_estado_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["minuta_id"], name: "index_bitacora_estados_on_minuta_id"
    t.index ["tipo_estado_id"], name: "index_bitacora_estados_on_tipo_estado_id"
  end

  create_table "bitacora_revisiones", force: :cascade do |t|
    t.string "revision"
    t.bigint "motivo_id", null: false
    t.bigint "minuta_id", null: false
    t.boolean "emitida", default: false
    t.boolean "activa", default: true
    t.datetime "fecha_emision"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["minuta_id"], name: "index_bitacora_revisiones_on_minuta_id"
    t.index ["motivo_id"], name: "index_bitacora_revisiones_on_motivo_id"
  end

  create_table "clasificaciones", force: :cascade do |t|
    t.boolean "informativa", default: false
    t.boolean "avance", default: false
    t.boolean "coordinacion", default: false
    t.boolean "decision", default: false
    t.boolean "otro", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "comentarios", force: :cascade do |t|
    t.text "comentario"
    t.boolean "es_item"
    t.bigint "id_item"
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.bigint "asistencia_id", null: false
    t.bigint "minuta_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["asistencia_id"], name: "index_comentarios_on_asistencia_id"
    t.index ["minuta_id"], name: "index_comentarios_on_minuta_id"
  end

  create_table "conclusiones", force: :cascade do |t|
    t.text "descripcion"
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "bitacora_revision_id", null: false
    t.index ["bitacora_revision_id"], name: "index_conclusiones_on_bitacora_revision_id"
  end

  create_table "cursos", force: :cascade do |t|
    t.string "nombre"
    t.string "codigo"
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "estudiantes", force: :cascade do |t|
    t.string "iniciales"
    t.bigint "usuario_id", null: false
    t.bigint "seccion_id", null: false
    t.bigint "grupo_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["grupo_id"], name: "index_estudiantes_on_grupo_id"
    t.index ["seccion_id"], name: "index_estudiantes_on_seccion_id"
    t.index ["usuario_id"], name: "index_estudiantes_on_usuario_id"
  end

  create_table "grupos", force: :cascade do |t|
    t.string "nombre"
    t.string "proyecto"
    t.integer "correlativo"
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "descripcion"
    t.integer "correlativo"
    t.datetime "fecha"
    t.boolean "resuelto"
    t.bigint "resuelto_por"
    t.datetime "resuelto_el"
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.bigint "bitacora_revision_id", null: false
    t.bigint "tipo_item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bitacora_revision_id"], name: "index_items_on_bitacora_revision_id"
    t.index ["tipo_item_id"], name: "index_items_on_tipo_item_id"
  end

  create_table "items_responsables", id: false, force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "responsable_id", null: false
    t.index ["item_id"], name: "index_items_responsables_on_item_id"
    t.index ["responsable_id"], name: "index_items_responsables_on_responsable_id"
  end

  create_table "jornadas", force: :cascade do |t|
    t.string "nombre"
    t.integer "identificador"
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "minutas", force: :cascade do |t|
    t.integer "correlativo"
    t.string "codigo"
    t.datetime "fecha_reunion"
    t.time "h_inicio"
    t.time "h_termino"
    t.bigint "estudiante_id", null: false
    t.bigint "tipo_minuta_id", null: false
    t.bigint "clasificacion_id", null: false
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["clasificacion_id"], name: "index_minutas_on_clasificacion_id"
    t.index ["estudiante_id"], name: "index_minutas_on_estudiante_id"
    t.index ["tipo_minuta_id"], name: "index_minutas_on_tipo_minuta_id"
  end

  create_table "motivos", force: :cascade do |t|
    t.string "motivo"
    t.string "identificador"
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "objetivos", force: :cascade do |t|
    t.text "descripcion"
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "bitacora_revision_id", null: false
    t.index ["bitacora_revision_id"], name: "index_objetivos_on_bitacora_revision_id"
  end

  create_table "profesores", force: :cascade do |t|
    t.bigint "usuario_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["usuario_id"], name: "index_profesores_on_usuario_id"
  end

  create_table "profesores_secciones", id: false, force: :cascade do |t|
    t.bigint "profesor_id", null: false
    t.bigint "seccion_id", null: false
    t.index ["profesor_id"], name: "index_profesores_secciones_on_profesor_id"
    t.index ["seccion_id"], name: "index_profesores_secciones_on_seccion_id"
  end

  create_table "registros", force: :cascade do |t|
    t.bigint "realizada_por"
    t.bigint "minuta_id", null: false
    t.bigint "tipo_actividad_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["minuta_id"], name: "index_registros_on_minuta_id"
    t.index ["tipo_actividad_id"], name: "index_registros_on_tipo_actividad_id"
  end

  create_table "responsables", force: :cascade do |t|
    t.bigint "asistencia_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["asistencia_id"], name: "index_responsables_on_asistencia_id"
  end

  create_table "respuestas", force: :cascade do |t|
    t.text "respuesta"
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.bigint "comentario_id", null: false
    t.bigint "asistencia_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["asistencia_id"], name: "index_respuestas_on_asistencia_id"
    t.index ["comentario_id"], name: "index_respuestas_on_comentario_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "rol"
    t.integer "rango"
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "secciones", force: :cascade do |t|
    t.string "codigo"
    t.bigint "jornada_id", null: false
    t.bigint "semestre_id", null: false
    t.bigint "curso_id", null: false
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["curso_id"], name: "index_secciones_on_curso_id"
    t.index ["jornada_id"], name: "index_secciones_on_jornada_id"
    t.index ["semestre_id"], name: "index_secciones_on_semestre_id"
  end

  create_table "semestres", force: :cascade do |t|
    t.integer "numero"
    t.integer "agno"
    t.boolean "activo", default: true
    t.datetime "inicio"
    t.datetime "fin"
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stakeholders", force: :cascade do |t|
    t.string "iniciales"
    t.bigint "usuario_id", null: false
    t.bigint "grupo_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["grupo_id"], name: "index_stakeholders_on_grupo_id"
    t.index ["usuario_id"], name: "index_stakeholders_on_usuario_id"
  end

  create_table "temas", force: :cascade do |t|
    t.string "tema"
    t.bigint "bitacora_revision_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bitacora_revision_id"], name: "index_temas_on_bitacora_revision_id"
  end

  create_table "tipo_actividades", force: :cascade do |t|
    t.string "actividad"
    t.string "descripcion"
    t.string "identificador"
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tipo_asistencias", force: :cascade do |t|
    t.string "tipo"
    t.string "descripcion"
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tipo_estados", force: :cascade do |t|
    t.string "abreviacion"
    t.string "descripcion"
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tipo_items", force: :cascade do |t|
    t.string "tipo"
    t.string "descripcion"
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tipo_minutas", force: :cascade do |t|
    t.string "tipo"
    t.string "descripcion"
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "nombre"
    t.string "apellido_paterno"
    t.string "apellido_materno"
    t.string "run"
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "borrado", default: false
    t.datetime "deleted_at"
    t.bigint "rol_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rol_id"], name: "index_usuarios_on_rol_id"
  end

  add_foreign_key "asistencias", "minutas"
  add_foreign_key "asistencias", "tipo_asistencias"
  add_foreign_key "bitacora_estados", "minutas"
  add_foreign_key "bitacora_estados", "tipo_estados"
  add_foreign_key "bitacora_revisiones", "minutas"
  add_foreign_key "bitacora_revisiones", "motivos"
  add_foreign_key "comentarios", "asistencias"
  add_foreign_key "comentarios", "minutas"
  add_foreign_key "conclusiones", "bitacora_revisiones"
  add_foreign_key "estudiantes", "grupos"
  add_foreign_key "estudiantes", "secciones"
  add_foreign_key "estudiantes", "usuarios"
  add_foreign_key "items", "bitacora_revisiones"
  add_foreign_key "items", "tipo_items"
  add_foreign_key "items_responsables", "items"
  add_foreign_key "items_responsables", "responsables"
  add_foreign_key "minutas", "clasificaciones"
  add_foreign_key "minutas", "estudiantes"
  add_foreign_key "minutas", "tipo_minutas"
  add_foreign_key "objetivos", "bitacora_revisiones"
  add_foreign_key "profesores", "usuarios"
  add_foreign_key "profesores_secciones", "profesores"
  add_foreign_key "profesores_secciones", "secciones"
  add_foreign_key "registros", "minutas"
  add_foreign_key "registros", "tipo_actividades"
  add_foreign_key "responsables", "asistencias"
  add_foreign_key "respuestas", "asistencias"
  add_foreign_key "respuestas", "comentarios"
  add_foreign_key "secciones", "cursos"
  add_foreign_key "secciones", "jornadas"
  add_foreign_key "secciones", "semestres"
  add_foreign_key "stakeholders", "grupos"
  add_foreign_key "stakeholders", "usuarios"
  add_foreign_key "temas", "bitacora_revisiones"
  add_foreign_key "usuarios", "roles"
end
