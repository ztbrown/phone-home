class TrackersController < ApplicationController
  before_action :set_tracker, only: [:show, :edit, :update, :destroy, :activate, :deactivate]

  # GET /trackers
  def index
    @trackers = current_user.trackers
  end

  # GET /trackers/1
  def show
    @activities = PublicActivity::Activity.where(trackable_type: 'Tracker', trackable_id: params[:id]).order('created_at DESC')
  end

  # GET /trackers/new
  def new
    @tracker = Tracker.new
  end

  # GET /trackers/1/edit
  def edit
  end

  # POST /trackers
  def create
    @tracker = current_user.trackers.build(tracker_params)

    if @tracker.save
      @tracker.create_activity(:created)

      redirect_to @tracker, notice: 'Tracker was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /trackers/1
  def update
    if @tracker.update(tracker_params)
      redirect_to @tracker, notice: 'Tracker was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /trackers/1
  def destroy
    @tracker.destroy

    redirect_to trackers_url
  end

  # PUT /trackers/1/activate
  def activate
    @tracker.update(active: true)
    @tracker.create_activity(:activated)

    redirect_to :back
  end

  # PUT /trackers/1/deactivate
  def deactivate
    @tracker.update(active: false)
    @tracker.create_activity(:deactivated)

    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tracker
      @tracker = Tracker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tracker_params
      params.require(:tracker).permit(:name)
    end
end
