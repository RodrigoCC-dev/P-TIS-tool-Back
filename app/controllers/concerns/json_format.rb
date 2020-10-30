module JsonFormat
  extend ActiveSupport::Concern

  def json_data
    { except: %i[created_at updated_at borrado deleted_at] }
  end

  def user_data
    {except: %i[created_at updated_at password_digest borrado deleted_at]}
  end
end
