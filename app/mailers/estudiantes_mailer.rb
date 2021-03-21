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
      mail(to: @estudiante.usuario.email, subject: "Se ha emitido una nueva minuta para su revisión", template_name: 'nueva_minuta_coordinacion')
    end
  end
end
