require 'spec_helper'

describe Api::V1::TrackersController do
  let!(:current_user) { create(:user, has_token: true) }

  describe '#create' do
    let(:create_params) { { tracker: { name: 'Name' }, auth_token: current_user.authentication_token } }

    it 'should create a tracker' do
      expect {
        post :create, create_params
      }.to change { current_user.trackers.count }.by(1)

      response.response_code.should == 200
    end

    it 'should serialize the tracker properly' do
      post :create, create_params

      tracker = current_user.trackers.last
      response.body.should be_json_eql(%({ "id": #{tracker.id}, "active": false, "user_id": #{current_user.id}, "name": "Name", "token": "#{tracker.token}" }))
    end

    it 'should log the creation activity' do
      expect {
        post :create, create_params
      }.to change { PublicActivity::Activity.where(trackable_type: 'Tracker', key: 'tracker.created').count }.by(1)
    end

    it 'should reject invalid parameters' do
      post :create, auth_token: current_user.authentication_token

      response.response_code.should == 400
    end
  end

  describe '#activate' do
    let(:tracker) { create(:tracker) }
    let(:activate_params) { { id: tracker.id, auth_token: current_user.authentication_token } }

    it 'should activate a tracker' do
      expect {
        put :activate, activate_params
      }.to change { tracker.reload.active? }.from(false).to(true)

      response.response_code.should == 200
    end

    it 'should log the activation activity' do
      expect {
        put :activate, activate_params
      }.to change { PublicActivity::Activity.where(trackable_type: 'Tracker', key: 'tracker.activated').count }.by(1)
    end

    it 'should reject invalid parameters' do
      put :activate, id: 1010101010101, auth_token: current_user.authentication_token

      response.response_code.should == 404
    end
  end

  describe '#deactivate' do
    let(:tracker) { create(:tracker, active: true) }
    let(:deactivate_params) { { id: tracker.id, auth_token: current_user.authentication_token } }

    it 'should deactivate a tracker' do
      expect {
        put :deactivate, deactivate_params
      }.to change { tracker.reload.active? }.from(true).to(false)

      response.response_code.should == 200
    end

    it 'should log the deactivation activity' do
      expect {
        put :deactivate, deactivate_params
      }.to change { PublicActivity::Activity.where(trackable_type: 'Tracker', key:
      'tracker.deactivated').count }.by(1)
    end

    it 'should reject invalid parameters' do
      put :deactivate, id: 1010101010101, auth_token: current_user.authentication_token

      response.response_code.should == 404
    end
  end
end
