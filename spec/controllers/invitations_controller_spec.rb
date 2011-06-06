require 'spec_helper'

describe InvitationsController do
  render_views

  describe "GET 'new'" do
    describe "as a non-signed-in user" do
      it "should fail" do
        get :new
        response.should_not be_success
      end
    end

    describe "as a non-admin user" do
      it "should fail" do
        @user = Factory(:user)
        test_sign_in(@user)
        get :new
        response.should_not be_success
      end
    end

    describe "as an admin" do
      before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
      end

      it "should be successful" do
        get 'new'
        response.should be_success
      end

      it "should have the right title" do
        get :new
        response.should have_selector("title", :content => "Invite users")
      end
    end
  end

  describe "POST 'create'" do
    describe "failure" do
      describe "as non-admin" do
        before(:each) do
          @attr = { :recipient_email => "" }
        end

        describe "as a non-signed-in user" do
          it "should deny access" do
            post :create, :invitation => @attr
            response.should redirect_to(signin_path)
          end
        end

        describe "as a non-admin user" do
          it "should protect the page" do
            @user = Factory(:user)
            test_sign_in(@user)
            post :create, :invitation => @attr
            response.should redirect_to(root_path)
          end
        end
      end

      describe "as admin" do
        before(:each) do
          @admin = Factory(:user, :email => "admin@example.com", :admin => true)
          test_sign_in(@admin)
        end

        it "should not create the invitation" do
          lambda do
            post :create, :invitation => @attr
          end.should_not change(Invitation, :count)
        end

        it "should have the right title" do
          get :new
          response.should have_selector("title", :content => "Invite users")
        end

        it "should render the 'new' page" do
          post :create, :invitation => @attr
          response.should render_template(:new)
        end
      end
    end

    describe "success" do
      before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
        @attr = { :recipient_email => "somethingnew@example.com" }
      end

      it "should create the invitation" do
        lambda do
          post :create, :invitation => @attr
        end.should change(Invitation, :count).by(1)
      end
    end
  end

end
