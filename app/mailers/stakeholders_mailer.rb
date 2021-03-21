class StakeholdersMailer < ApplicationMailer
  def comentariosMinuta(bitacora)
    @bitacora = bitacora
    @usuario = current_usuario
    asistencias = bitacora.minuta.asistencias.where.not(id_estudiante: nil)
    lista_ids = []
    asistencias.each do |a|
      lista_ids << a.id_estudiante
    end
    estudiantes = Estudiante.where(id: lista_ids)
    estudiantes.each do |est|
      @estudiante = est
      mail(to: @estudiante.usuario.email, subject: "Se ha realizado la revisión de una minuta de reunión", template_name: 'comentarios_cliente')
    end
  end

  def aprobacionMinuta(bitacora)
  end
end
