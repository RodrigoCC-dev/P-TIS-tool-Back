class EstudiantesMailer < ApplicationMailer
  def nuevaMinutaCoordinacion(bitacora)
    @bitacora = bitacora
    @emisor = bitacora.minuta.estudiante
    asistencias = bitacora.minuta.asistencias.where.not(id_estudiante: nil)
    lista_ids = []
    asistencias.each do |a|
      unless a.id_estudiante == bitacora.minuta.estudiante_id
        lista_ids << a.id_estudiante
      end
    end
    usuarios = Estudiante.joins(:usuario).where(id: lista_ids).select('usuarios.email AS correo')
    emails = usuarios.collect(&:correo).join(', ')
    mail(to: emails, subject: "Hay una nueva minuta de reunión que requiere tu revisión", template_name: 'nueva_minuta_coordinacion')
  end

  def notificacionEstudiantes(emisor, bitacora, estudiante)
    @emisor = emisor
    @bitacora = bitacora
    @estudiante = estudiante
    mail(to: @estudiante.usuario.email, subject: "Hay una nueva minuta de reunión que requiere tu revisión", template_name: 'nueva_minuta_coordinacion')
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
    stakeholders = Stakeholder.where(id: lista_ids)
    stakeholders.each do |stk|
      @stakeholder = stk
      mail(to: @stakeholder.usuario.email, subject: "Se ha emitido una nueva minuta para su revisión", template_name: 'minuta_revision_cliente')
    end
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
end
