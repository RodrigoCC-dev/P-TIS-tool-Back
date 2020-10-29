module JsonFormat
  extend ActiveSupport::Concern

  def json_data
    { except: %i[created_at updated_at borrado deleted_at] }
  end
end
