class StakeholdersMailer < ApplicationMailer
  def comentariosMinuta(bitacora, usuario)
    @bitacora = bitacora
    @usuario = usuario
    @estudiante = bitacora.minuta.estudiante
    mail(to: @estudiante.usuario.email, subject: "Se ha realizado la revisión de una minuta de reunión", template_name: 'comentarios_cliente')
  end

  def aprobacionMinuta(bitacora, usuario)
    @bitacora = bitacora
    @usuario = usuario
    @estudiante = bitacora.minuta.estudiante
    mail(to: @estudiante.usuario.email, subject: "Ha concluido la revisión de una minuta de reunión por parte del cliente", template_name: 'aprobacion_cliente')
  end
end
