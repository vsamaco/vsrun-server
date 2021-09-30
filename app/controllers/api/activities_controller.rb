class Api::ActivitiesController < Api::BaseController

  before_action :find_activity, only: %w[show]

  def show
    render_jsonapi_response(@activity)
  end

  private

  def find_activity
    @activity = Activity.find(params[:id])
  end

end