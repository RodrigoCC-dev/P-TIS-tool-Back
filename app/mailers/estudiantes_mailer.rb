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
    estudiantes = Estudiante.where(id: lista_ids)
    estudiantes.each do |est|
      @estudiante = est
      mail(to: @estudiante.usuario.email, subject: "Hay una nueva minuta de reunión que requiere tu revisión", template_name: 'nueva_minuta_coordinacion')
    end
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
end
