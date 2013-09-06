class ImagesController < ApplicationController
  skip_before_filter :authenticate_user!, only: :show

  def show
    # Log the activity on the relevant tracker.
    tracker = Tracker.find_by(token: params[:token])
    tracker.create_activity(:viewed, params: { ip: request.remote_ip }) if tracker.present?

    # Send along the tracking image.
    send_data open("#{Rails.root}/public/transparent.gif", 'rb') { |f| f.read }, filename: 'transparent.gif', type: 'image/gif'
  end
end