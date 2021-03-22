# Preview all emails at http://localhost:3000/rails/mailers/estudiantes_mailer
class EstudiantesMailerPreview < ActionMailer::Preview
  def nuevaMinutaCoordinacion
    bitacora = BitacoraRevision.first
    EstudiantesMailer.nuevaMinutaCoordinacion(bitacora)
  end

  def revisionCliente
    bitacora = BitacoraRevision.where(motivo_id: Motivo.find_by(identificador: 'ERC').id).last
    EstudiantesMailer.revisionCliente(bitacora)
  end

  def respuestaAlCliente
    bitacora = BitacoraRevision.where(motivo_id: Motivo.find_by(identificador: 'EAC')).last
    EstudiantesMailer.respuestaAlCliente(bitacora)
  end
end
