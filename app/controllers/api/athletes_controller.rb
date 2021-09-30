class Api::AthletesController < Api::BaseController

  before_action :find_athlete, only: %w[show]

  def show
    render_jsonapi_response(@athlete)
  end

  private

  def find_athlete
    @athlete = Athlete.find(params[:id])
  end

end