class EstudiantesMailer < ApplicationMailer
  def nuevaMinutaCoordinacion(bitacora)
    @bitacora = bitacora
    @emisor = bitacora.minuta.estudiante
    emails = obtener_correos_estudiantes(bitacora)
    mail(to: emails, subject: "Hay una nueva minuta de reunión que requiere tu revisión", template_name: 'nueva_minuta_coordinacion')
  end

  def revisionCliente(bitacora)
    @bitacora = bitacora
    @emisor = bitacora.minuta.estudiante
    @grupo = @emisor.grupo
    asistencias = bitacora.minuta.asistencias.where.not(id_stakeholder: nil)
    lista_ids = []
    asistencias.each do |a|
      lista_ids << a.id_stakeholder
    end
    stakeholders = Stakeholder.joins(:usuario).where(id: lista_ids).select('usuarios.email AS correo')
    emails = stakeholders.collect(&:correo).join(', ')
    mail(to: emails, subject: "Se ha emitido una nueva minuta para su revisión", template_name: 'minuta_revision_cliente')
  end

  def avisoAestudiantes(bitacora)
    @bitacora = bitacora
    @emisor = bitacora.minuta.estudiante
    emails = obtener_correos_estudiantes(bitacora)
    mail(to: emails, subject: "Se ha emitido una minuta para revisión del cliente", template_name: 'aviso_a_estudiantes')
  end

  def respuestaAlCliente(bitacora)
    @bitacora = bitacora
    @emisor = bitacora.minuta.estudiante
    @grupo = @emisor.grupo
    asistencias = bitacora.minuta.asistencias.where.not(id_stakeholder: nil)
    lista_ids = []
    asistencias.each do |a|
      lista_ids << a.id_stakeholder
    end
    stakeholders = Stakeholder.where(id: lista_ids)
    stakeholders.each do |stk|
      @stakeholder = stk
      mail(to: @stakeholder.usuario.email, subject: "Se han respondido los comentarios realizados a la minuta #{@bitacora.minuta.codigo}_#{@bitacora.revision}", template_name: 'respuestas_a_comentarios')
    end
  end

  private
  def obtener_correos_estudiantes(bitacora)
    asistencias = bitacora.minuta.asistencias.where.not(id_estudiante: nil)
    lista_ids = []
    asistencias.each do |a|
      unless a.id_estudiante == bitacora.minuta.estudiante_id
        lista_ids << a.id_estudiante
      end
    end
    estudiantes = Estudiante.joins(:usuario).where(id: lista_ids).select('usuarios.email AS correo')
    emails = estudiantes.collect(&:correo).join(', ')
    return emails
  end
end
