class ImagesController < ApplicationController
  skip_before_filter :authenticate_user!, only: :show

  def show
    # Log the activity on the relevant tracker.
    tracker = Tracker.find_by(token: params[:token])
    tracker.create_activity(:viewed, params: { ip: request.remote_ip, city: request.location.city, state: request.location.region_name, country: request.location.country_name }) if tracker.present? and tracker.active?

    # Send along the tracking image.
    send_data open("#{Rails.root}/public/transparent.gif", 'rb') { |f| f.read }, filename: 'transparent.gif', type: 'image/gif'
  end
end