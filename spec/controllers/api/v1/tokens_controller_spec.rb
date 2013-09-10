require 'spec_helper'

describe Api::V1::TokensController do
  describe 'with valid credentials' do
    it 'creates an authentication token' do
      user = create(:user)

      post :create, email: user.email, password: 'changeme'

      user.reload
      user.authentication_token.should_not be_blank

      response.response_code.should == 200
      response.body.should == {
          auth_token: user.authentication_token
      }.to_json
    end

    it 'returns the existing authentication token' do
      user = create(:user)
      user.reset_authentication_token!

      token = user.authentication_token

      post :create, email: user.email, password: 'changeme'

      user.reload
      user.authentication_token.should == token

      response.response_code.should == 200
      response.body.should == {
          auth_token: token
      }.to_json
    end

    it 'destroys an authentication token' do
      user = create(:user)
      user.reset_authentication_token!

      delete :destroy, auth_token: user.authentication_token

      user.reload
      user.authentication_token.should be_nil

      response.response_code.should == 200
      response.body.should == nil.to_json
    end
  end

  describe 'without valid credentials' do
    it 'does not create an authentication token with invalid password' do
      user = create(:user, has_token: false)

      post :create, email: user.email, password: 'badpassword'

      user.reload
      user.authentication_token.should be_blank

      response.response_code.should == 401
      response.body.should == {
          error: 'Invalid email or password'
      }.to_json
    end

    it 'does not create an authentication token with invalid email' do
      user = create(:user, has_token: false)

      post :create, email: 'nobody@example.com', password: 'changeme'

      user.reload
      user.authentication_token.should be_blank

      response.response_code.should == 401
      response.body.should == {
          error: 'Invalid email or password'
      }.to_json
    end
  end
end