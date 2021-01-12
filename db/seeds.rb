# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Seeder para Roles
Rol.create!([
  {
    "rol" => "Coordinador",
    "rango" => 1
  },
  {
    "rol" => "Profesor",
    "rango" => 2
  },
  {
    "rol" => "Estudiante",
    "rango" => 3
  },
  {
    "rol" => "Stakeholder",
    "rango" => 4
  }
])

# Seeder para agregar Jornadas
Jornada.create!([
  {
    "nombre" => "Diurna",
    "identificador" => 1
  },
  {
    "nombre" => "Vespertina",
    "identificador" => 2
  }
])

# Seeder para agregar Semestres
Semestre.create!([
  {
    "numero" => 2,
    "agno" => 2020,
    "activo" => true,
    "inicio" => "2020-09-28",
    "fin" => "2021-01-29"
  }
])

# Seeder para agregar Cursos
Curso.create!([
  {
    "nombre" => "Proyecto de Ingenieria de Software",
    "codigo" => "13168"
  },
  {
    "nombre" => "Proyecto de Ingenieria Informatica",
    "codigo" => "13126"
  },
  {
    "nombre" => "Proyecto de Ingenieria de Software",
    "codigo" => "13267"
  },
  {
    "nombre" => "Taller de Ingenieria de Software",
    "codigo" => "13230"
  }
])

# Seeder para crear secciones
jornadas = Jornada.all
semestres = Semestre.all
cursos = Curso.all
Seccion.create!([
  {
    "codigo" => "A1",
    "jornada" => jornadas.find_by(identificador: 1),
    "semestre" => semestres.first,
    "curso" => cursos.find_by(codigo: '13267')
  },
  {
    "codigo" => "B2",
    "jornada" => jornadas.find_by(identificador: 1),
    "semestre" => semestres.first,
    "curso" => cursos.find_by(codigo: '13230')
  },
  {
    "codigo" => "V21",
    "jornada" => jornadas.find_by(identificador: 2),
    "semestre" => semestres.first,
    "curso" => cursos.find_by(codigo: '13168')
  },
  {
    "codigo" => "V35",
    "jornada" => jornadas.find_by(identificador: 2),
    "semestre" => semestres.first,
    "curso" => cursos.find_by(codigo: '13126')
  }
])

# Seeder para crear usuarios
roles = Rol.all
Usuario.create!([
  {
    "nombre" => "Hector",
    "apellido_paterno" => "Antillanca",
    "apellido_materno" => "Espina",
    "email" => "hector.antillanca@usach.cl",
    "password" => "secret",
    "password_confirmation" => "secret",
    "rol" => roles.find_by(rango: 1)
  },
  {
    "nombre" => "Maria Carolina",
    "apellido_paterno" => "Chamorro",
    "apellido_materno" => "Ahumada",
    "email" => "mcchamorro@gmail.com",
    "password" => "secret",
    "password_confirmation" => "secret",
    "rol" => roles.find_by(rango: 2)
  }
])

# Seeder para agregar tipos de minutas
TipoMinuta.create!([
  {
    "tipo" => "Coordinacion",
    "descripcion" => "Minuta para reunión entre los estudiantes de un grupo de trabajo"
  },
  {
    "tipo" => "Cliente",
    "descripcion" => "Minuta para reunión del grupo de trabajo con los stakeholders"
  },
  {
    "tipo" => "Semanal",
    "descripcion" => "Minuta para reunión semanal para señalar logros y metas"
  }
])

# Seeder para agregar tipos de asistencia
TipoAsistencia.create!([
  {
    "tipo" => "PRE",
    "descripcion" => "Presente"
  },
  {
    "tipo" => "AUS",
    "descripcion" => "Ausente"
  },
  {
    "tipo" => "ACA",
    "descripcion" => "Ausente con aviso"
  }
])

# Seeder para agregar tipos de ítems
TipoItem.create!([
  {
    "tipo" => "Agenda",
    "descripcion" => "Comprimiso con fecha y responsable",
    "rango" => 1
  },
  {
    "tipo" => "Decisión",
    "descripcion" => "Acuerdo de trabajo",
    "rango" => 1
  },
  {
    "tipo" => "Compromiso",
    "descripcion" => "Acuerdo de trabajo con responsabilidad",
    "rango" => 1
  },
  {
    "tipo" => "Hecho",
    "descripcion" => "Tarea terminada",
    "rango" => 1
  },
  {
    "tipo" => "Info",
    "descripcion" => "Item informativo",
    "rango" => 1
  },
  {
    "tipo" => "Idea",
    "descripcion" => "Propuesta formulada en la reunión",
    "rango" => 1
  },
  {
    "tipo" => "Por hacer",
    "descripcion" => "Tarea por realizar",
    "rango" => 1
  },
  {
    "tipo" => "Logro",
    "descripcion" => "Logro conseguido durante la semana de trabajo",
    "rango" => 2
  },
  {
    "tipo" => "Meta",
    "descripcion" => "Meta a conseguir en la siguiente semana de trabajo",
    "rango" => 2
  }
])

# Seeder para agregar motivos de revisión
Motivo.create!([
  {
    "motivo" => "Emitida para coordinación interna",
    "identificador" => "ECI"
  },
  {
    "motivo" => "Emitida para revisión del cliente",
    "identificador" => "ERC"
  },
  {
    "motivo" => "Emitida para aprobación del cliente",
    "identificador" => "EAC"
  },
  {
    "motivo" => "Emisión final",
    "identificador" => "EF"
  }
])

# Seeder para agregar Tipos de estados
TipoEstado.create!([
  {
    "abreviacion" => "BOR",
    "descripcion" => "Borrador"
  },
  {
    "abreviacion" => "EMI",
    "descripcion" => "Emitida"
  },
  {
    "abreviacion" => "CIG",
    "descripcion" => "Comentada por integrante del grupo"
  },
  {
    "abreviacion" => "CSK",
    "descripcion" => "Comentada por Stakeholder"
  },
  {
    "abreviacion" => "RIG",
    "descripcion" => "Respondida por integrante del grupo"
  },
  {
    "abreviacion" => "RSK",
    "descripcion" => "Respondida por Stakeholder"
  },
  {
    "abreviacion" => "CER",
    "descripcion" => "Cerrada"
  }
])

# Seeder para agregar Tipos de actividades
TipoActividad.create!([
  {
    "actividad" => "Crear minuta",
    "descripcion" => "Se creó una nueva minuta de reunión",
    "identificador" => "M1"
  },
  {
    "actividad" => "Ingresar datos de reunión",
    "descripcion" => "Se registran los datos de la reunión en la minuta",
    "identificador" => "M2"
  },
  {
    "actividad" => "Ingresar tema de reunión",
    "descripcion" => "Se ingresa el tema de la reunión a tratar",
    "identificador" => "T1"
  },
  {
    "actividad" => "Modifica tema de reunión",
    "descripcion" => "Se cambia el tema de la reunión de la minuta",
    "identificador" => "T2"
  },
  {
    "actividad" => "Ingresar asistencia",
    "descripcion" => "Se ingresa los asistentes de la reunión",
    "identificador" => "M3"
  },
  {
    "actividad" => "Ingresar clasificación",
    "descripcion" => "Se ingresa la clasificación de la reunión",
    "identificador" => "M4"
  },
  {
    "actividad" => "Ingresar objetivo",
    "descripcion" => "Se ingresa un objetivo de la reunión",
    "identificador" => "O1"
  },
  {
    "actividad" => "Editar objetivo",
    "descripcion" => "Se cambia objetivo de la reunión",
    "identificador" => "O2"
  },
  {
    "actividad" => "Eliminar objetivo",
    "descripcion" => "Se quita objetivo de la reunión",
    "identificador" => "O3"
  },
  {
    "actividad" => "Ingresar conclusión",
    "descripcion" => "Se ingresa una conclusión de la reunión",
    "identificador" => "C1"
  },
  {
    "actividad" => "Editar conclusión",
    "descripcion" => "Se cambia conclusión de la reunión",
    "identificador" => "C2"
  },
  {
    "actividad" => "Eliminar conclusión",
    "descripcion" => "Se quita conclusión de la reunión",
    "identificador" => "C3"
  },
  {
    "actividad" => "Ingresar item",
    "descripcion" => "Se ingresa un nuevo item a la reunión",
    "identificador" => "M5"
  },
  {
    "actividad" => "Asignar responsable",
    "descripcion" => "Se indica responsable del item",
    "identificador" => "R1"
  },
  {
    "actividad" => "Ingresar fecha",
    "descripcion" => "Se agrega fecha de cumplimiento del compromiso",
    "identificador" => "F1"
  },
  {
    "actividad" => "Modificar item",
    "descripcion" => "Se cambia descripción del item",
    "identificador" => "M6"
  },
  {
    "actividad" => "Cambiar responsable",
    "descripcion" => "Se cambia el responsable del item",
    "identificador" => "R2"
  },
  {
    "actividad" => "Cambiar fecha",
    "descripcion" => "Se cambia fecha del compromiso",
    "identificador" => "F2"
  },
  {
    "actividad" => "Eliminar item",
    "descripcion" => "Se elmina el item",
    "identificador" => "M7"
  },
  {
    "actividad" => "Quitar responsable",
    "descripcion" => "Se quita el responsable del item",
    "identificador" => "R3"
  },
  {
    "actividad" => "Quitar fecha",
    "descripcion" => "Se quita la fecha de cumplimento del compromiso",
    "identificador" => "F3"
  },
  {
    "actividad" => "Agrega comentario",
    "descripcion" => "Se agrega comentario a un item",
    "identificador" => "COM1"
  },
  {
    "actividad" => "Editar comentario",
    "descripcion" => "Se cambia un comentario a un item",
    "identificador" => "COM2"
  },
  {
    "actividad" => "Eliminar comentario",
    "descripcion" => "Se elimina el comentario del item",
    "identificador" => "COM3"
  },
  {
    "actividad" => "Agregar respuesta",
    "descripcion" => "Se agrega respuesta a un comentario",
    "identificador" => "RE1"
  },
  {
    "actividad" => "Editar respuesta",
    "descripcion" => "Se cambia respuesta a un comentario",
    "identificador" => "RE2"
  },
  {
    "actividad" => "Eliminar respuesta",
    "descripcion" => "Se quita respuesta a un comentario",
    "identificador" => "RE3"
  },
  {
    "actividad" => "Modificar datos minuta",
    "descripcion" => "Se cambian datos de minuta",
    "identificador" => "M8"
  },
  {
    "actividad" => "Modifica clasificación",
    "descripcion" => "Se actualiza la clasificación de la minuta",
    "identificador" => "M9"
  },
  {
    "actividad" => "Modifica asistencia",
    "descripcion" => "Se actualiza la asistencia de la minuta",
    "identificador" => "M10"
  },
  {
    "actividad" => "Crea minuta avance",
    "descripcion" => "Se creó una minuta de avance semanal"
    "identificador" => "A1"
  },
  {
    "actividad" => "Registrar un logro",
    "descripcion" => "Se registra un logro en una minuta de avance semanal",
    "identificador" => "L1"
  },
  {
    "actividad" => "Registrar una meta",
    "descripcion" => "Se registra una meta en una minuta de avance semanal",
    "identificador" => "MT1"
  },
  {
    "actividad" => "Cambiar número Sprint",
    "descripcion" => "Se actualiza número de Sprint en minuta de avance semanal",
    "identificador" => "NS1"
  },
  {
    "actividad" => "Cambiar fecha minuta semanal",
    "descripcion" => "Se actualiza fecha de avance semanal"
    "identificador" => "F4"
  }
])

# Seeder para agregar grupo por defecto
grupo = Grupo.new
grupo.nombre = 'SG'
grupo.proyecto = 'Sin asignacion'
grupo.save(validate: false)

# Seeder para crear profesores
usuarios = Usuario.all
Profesor.create!([
  {
    "usuario" => usuarios.find_by(email: 'mcchamorro@gmail.com')
  }
])

# Seeder para asignar secciones a los profesores
profesores = Profesor.all
profesor_uno = profesores.first
secciones = Seccion.joins(:jornada)
profesor_uno.secciones << secciones.where('jornadas.identificador =?', 2)
profesor_uno.save!

# Seeder para agregar Tipos de Aprobaciones
TipoAprobacion.create!([
  {
    "identificador" => "A",
    "descripcion" => "Aprobada",
    "rango" => 1
  },
  {
    "identificador" => "AC",
    "descripcion" => "Aprobada con comentarios",
    "rango" => 2
  },
  {
    "identificador" => "R",
    "descripcion" => "Rechazada",
    "rango" => 3
  },
  {
    "identificador" => "RC",
    "descripcion" => "Rechazada con comentarios",
    "rango" => 4
  }
  ])
