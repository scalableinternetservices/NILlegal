require 'rails_helper'

RSpec.describe DareSubmissionsController, type: :controller do
  render_views
  
  describe 'GET new_dare_submission' do
    context "logged in user" do
      before do
        sign_in_user
        dare = FactoryGirl.create(:dare)
        get :new, 
          params: {dare_submission: {dare_id: dare.id}}
      end
  
      it 'routes to dares_submissions#create' do
        expect(:get => new_dare_submission_path).to route_to(
          :controller => "dare_submissions",
          :action => "new"
        )
      end
  
      it 'returns 200 OK' do
        assert_response :success
      end
  
      it 'renders correct view' do
        assert_template :new
      end
    end  
  context "invalid dare id" do
    before do
      sign_in_user
    end
    it "redirects to show_dare_list_path when id for dare doesn't exist" do
      get :new, 
        params: {dare_submission: {dare_id: 9}}
      expect(response).to redirect_to show_dare_list_path
      assert_equal flash.empty?, false
      expect(flash[:danger]).to match("Cannot Submit to Nonexistent Dare")
    end
    
  end
    
    context "not logged in" do
      before do
        
      end
      
      it 'redirects to sign in' do
        dare = FactoryGirl.create(:dare)
        get :new, 
          params: {dare_submission: {dare_id: dare.id}}
        expect(response).to redirect_to new_user_session_path
      end  
    end
  end
  
  describe 'POST new_dare_submission' do
    context "valid user" do
      before do
        sign_in_user
      end   
      
      context "with invalid attributes" do
        it "does not save the new dare submission" do
          dare = FactoryGirl.create(:dare)
          expect{
            post :create,
              params: { dare_submission: {dare_id: dare.id} }
          }.to_not change(DareSubmission,:count)
        end
        
        it "re-renders the new method" do
          
          dare = FactoryGirl.create(:dare)
          post :create,
            params: { dare_submission: {dare_id: dare.id} }
          expect(response).to render_template :new
          assert_select "div.alert", "The form contains 3 errors."
        end
      end
      
      
      context "with valid attributes" do
        it "saves the new post" do
          dare = FactoryGirl.create(:dare)
          expect{
            post :create,
              params: { dare_submission:{  
                          content:"https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                          description: "MyText",
                          dare_id: dare.id} }
          }.to change(DareSubmission,:count).by(1)
        end
        
        it "renders the dare's page" do
          dare = FactoryGirl.create(:dare)
          post :create,
            params: { dare_submission:{  
                          content:"https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                          description: "MyText",
                          dare_id: dare.id} }
          expect(response).to redirect_to dare_path(dare.id)
          assert_equal flash.empty?, false
          expect(flash[:success]).to match("Dare Submission created!")
          
        end
      end
    end
    
    context "not logged in" do
      it 'redirects to sign in' do
        post :create,
          params: {dare: FactoryGirl.attributes_for(:dare)}
        expect(response).to redirect_to new_user_session_path
      end 
      it "post is not saved" do
        expect{
            post :create, 
              params: {dare: FactoryGirl.attributes_for(:dare)}
        }.to change(Dare,:count).by(0)
      end
    end
  end
  
  
  describe 'GET edit page' do
    context "valid user" do
      before do
        sign_in_user
        @dare = FactoryGirl.create(:dare)
        post :create,
          params: { dare_submission:{  
                      content:"https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                      description: "MyText",
                      dare_id: @dare.id} }
        get :edit,
          params: {id: @dare.dare_submissions.first.id}
      end
      it 'routes to dares_submissions#edit' do
        expect(:get => edit_dare_submission_path(@dare.dare_submissions.first.id)).to route_to(
          :controller => "dare_submissions",
          :action => "edit",
          :id=>"#{@dare.dare_submissions.first.id}"
        )
      end
  
      it 'returns 200 OK' do
        assert_response :success
      end
  
      it 'renders correct view' do
        assert_template :edit
      end
      
      it "redirect to root_url when wrong dare submission" do
        get :edit,
              params: {id: 2}
        expect(response).to redirect_to root_path
      end
    end
    context "invalid user" do
      it "redirect sign in when not logged in" do
        get :edit,
              params: {id: 1}
        expect(response).to redirect_to new_user_session_path
      end
      
    end
  end
  
  describe 'PATCH dare_submission' do
    context "valid user" do
      before do
        sign_in_user
        @dare = FactoryGirl.create(:dare)
        post :create,
          params: { dare_submission:{  
                      content:"https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                      description: "MyText",
                      dare_id: @dare.id} }
      
      end
      context "invalid attributes" do
        it 're-renders edit view' do
          patch :update,
            params: { 
              id: @dare.dare_submissions.first.id,
              dare_submission:{  
                          content:"https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                          description: "",
                          dare_id: @dare.id}
                          }
          expect(response).to render_template :edit
          assert_select "div.alert", "The form contains 1 error."
        end
      end
      context "valid attributes" do
        it 're-renders edit view' do
          patch :update,
            params: { 
              id: @dare.dare_submissions.first.id,
              dare_submission:{  
                          content:"https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                          description: "Test1",
                          dare_id: @dare.id}
                          }
          expect(response).to redirect_to dare_path(@dare.id)
          assert_equal flash.empty?, false
          expect(flash[:success]).to match("Submission updated")
        end
        it "redirect to root_url when wrong dare submission" do
          patch :update,
            params: { 
              id: 2,
              dare_submission:{  
                          content:"https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                          description: "Test1",
                          dare_id: @dare.id}
                          }
          expect(response).to redirect_to root_path
        end
      end
      
    end
    context "invalid user" do
      it "redirect sign in when not logged in" do
        patch :update,
          params: { 
            id: 1,
            dare_submission:{  
                        content:"https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                        description: "Test1",
                        dare_id: 1}
                        }
        expect(response).to redirect_to new_user_session_path
      end
      
    end
    
    
    
  end
  
  
  
  
  
  

end
