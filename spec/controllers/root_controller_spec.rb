require 'spec_helper'

RSpec.describe RootController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      create :basic_user
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
