# Preview all emails at http://localhost:3000/rails/mailers/stakeholders_mailer
class StakeholdersMailerPreview < ActionMailer::Preview
  def comentariosMinuta
    bitacora = BitacoraRevision.last
    asistencia = bitacora.minuta.asistencias.where.not(id_stakeholder: nil).last
    usuario = Stakeholder.find(asistencia.id_stakeholder).usuario
    StakeholdersMailer.comentariosMinuta(bitacora, usuario)
  end
end
