class Api::ActivitiesController < Api::BaseController

  before_action :find_activity, only: %w[show]

  def show
    render_jsonapi_response(@activity)
  end

  def index
    @activities = Activity.includes(:athlete).where(index_params).to_a
    render_jsonapi_response(@activities)
  end

  private

  def index_params
    params.permit(:athlete_id)
  end

  def find_activity
    @activity = Activity.find(params[:id])
  end

end