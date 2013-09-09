module Api
  module V1
    class TrackersController < ApiController
      before_action :set_tracker, only: [:activate, :deactivate]

      # POST /trackers
      def create
        @tracker = current_user.trackers.build(tracker_params)

        if @tracker.save
          @tracker.create_activity(:created)
        end


        render json: @tracker, status: 200
      end

      # PUT /trackers/1/activate
      def activate
        @tracker.update(active: true)
        @tracker.create_activity(:activated)

        render json: @tracker, status: 200
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

  end
end