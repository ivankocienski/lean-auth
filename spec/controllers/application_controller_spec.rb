require 'spec_helper'

describe ApplicationController, type: :controller do 

  let( :user ) { create :basic_user }
  let( :session_args ) { { user_id: user.id } }

  context 'auth filters' do

    context 'user_must_be_logged_in' do

      controller do
        before_filter :user_must_be_logged_in!

        def index
          render :nothing => true
        end
      end

      it 'should reject if not logged in' do 
        get :index

        expect(response).to redirect_to( root_path )
        expect(flash[:error]).to eq 'You must be logged in to access that page'
      end

      it 'should allow if logged in' do
        get :index, {}, session_args

        expect(response).not_to redirect_to( root_path )
        expect(flash).to be_empty
      end
    end

    context 'user_must_NOT_be_logged_in' do

      controller do
        before_filter :user_must_NOT_be_logged_in!

        def index
          render :nothing => true
        end
      end

      it 'should reject if logged in' do
        get :index, {}, session_args

        expect(response).to redirect_to( root_path )
        expect(flash[:error]).to eq 'You must not be logged in to access that page'
      end

      it 'should allow if not logged in' do
        get :index

        expect(response).not_to redirect_to( root_path )
        expect(flash).to be_empty
      end
    end
  end


end
