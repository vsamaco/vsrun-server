class CurrentUserController < ApplicationController
  before_action :check_headers
  before_action :authenticate_user!

  def index
    render_jsonapi_response(current_user)
  end

  private

  def check_headers
    if request.headers['Authorization'].nil?
      render json: {
        error: 'Missing authentication'
      }, status: 401
    end
  end
end
