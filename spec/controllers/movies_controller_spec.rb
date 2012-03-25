require 'spec_helper'

describe MoviesController do
  describe 'find movies by director' do
    it 'should call model method to get the current movie' do
      Movie.should_receive(:find)
      post :find_by_director, :id=>0
    end
    it 'should call the model method that returns all movies by this director' do
      Movie.stub(:find).and_return(mock('Movie', :director=>'Tarantino'))
      Movie.should_receive(:find_all_by_director)
      post :find_by_director,:id=>0
    end
    it 'should return all movies returned by the model method' do
      result=Array.new(5).collect{mock('Movie')}
      Movie.stub(:find).and_return(mock('Movie', :director=>'Tarantino'))
      Movie.stub(:find_all_by_director).and_return(result)
      post :find_by_director,:id=>0
      assigns(:director_movies).should eq(result)
      assigns(:director).should eq('Tarantino')
    end
    describe 'on error should redirect to home page' do
      it 'in case no movies returned' do
        Movie.stub(:find).and_return(mock('Movie', :director=>'Tarantino'))
        Movie.stub(:find_all_by_director).and_return([])
        post :find_by_director,:id=>0
        response.should redirect_to(movies_path)
      end
      it 'in case the current movie has no director' do
        Movie.stub(:find).and_return(mock('Movie', :director=>nil, :title=>'Kill Bill'))
        post :find_by_director,:id=>0
        response.should redirect_to(movies_path)
      end
    end
    it 'should display error message when the movie has no director' do
      Movie.stub(:find).and_return(mock('Movie', :director=>nil, :title=>'Kill Bill'))
      post :find_by_director,:id=>0
      flash[:notice].should eq("'Kill Bill' has no director info")
    end
  end
  
  describe 'create a movie' do
    it 'should call model method to create new movie' do
      m=mock('Movie', :title=>'Titanic')
      Movie.should_receive(:create!).and_return(m)
      post :create, :movie => m
    end
    it 'should redirect to home page' do
      m=mock('Movie', :title=>'Titanic')
      Movie.stub(:create!).and_return(m)
      post :create, :movie => m
      response.should redirect_to(movies_path)
    end
    it 'should display message that the movie is created' do
      m=mock('Movie', :title=>'Titanic')
      Movie.stub(:create!).and_return(m)
      post :create, :movie => m
      flash[:notice].should eq("Titanic was successfully created.")   
    end
  end
  
  describe 'delete a movie' do
    it 'should call model method to get the movie from id' do
      m=mock('Movie', :title=>'Titanic')
      m.stub(:destroy)
      Movie.should_receive(:find).and_return(m)
      post :destroy, :id => 0
    end
  
    it 'should call model method to destroy the movie' do
      m=mock('Movie', :title=>'Titanic')
      Movie.stub(:find).and_return(m)
      m.should_receive(:destroy)
      post :destroy, :id => 0
    end
    it 'should redirect to home page' do
      m=mock('Movie', :title=>'Titanic')
      Movie.stub(:find).and_return(m)
      m.stub(:destroy)
      post :destroy, :id => 0
      response.should redirect_to(movies_path)
    end
    it 'should display message that the movie is created' do
      m=mock('Movie', :title=>'Titanic')
      Movie.stub(:find).and_return(m)
      m.stub(:destroy)
      post :destroy, :id => 0
      flash[:notice].should eq("Movie 'Titanic' deleted.")   
    end
  end
  
end
