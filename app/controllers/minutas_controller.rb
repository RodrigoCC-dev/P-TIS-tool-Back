class MinutasController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  def create
  end
  
end
