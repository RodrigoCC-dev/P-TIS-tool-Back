# Preview all emails at http://localhost:3000/rails/mailers/estudiantes_mailer
class EstudiantesMailerPreview < ActionMailer::Preview
  def nuevaMinutaCoordinacion
    bitacora = BitacoraRevision.last
    EstudiantesMailer.nuevaMinutaCoordinacion(bitacora)
  end

  def revisionCliente
    bitacora = BitacoraRevision.last
    EstudiantesMailer.revisionCliente(bitacora)
  end
end
