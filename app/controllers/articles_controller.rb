class ArticlesController < ApplicationController

	skip_before_action :verify_authenticity_token
	# http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]
	
	def index
		@articles = Article.all
		render json: @articles
	end

	def show
	  @article = Article.find_by_id(params[:id])
	  if @article
	   render json: @article
	 else
	 	 render json: { message: "data not found" }
	 end
	end

	def new
	  @article = Article.new
	end

	def create
	  @article = Article.new(article_params)

	  if @article.save
	  	flash[:notice] = "Thanks For The Article"
	    render json: @article
	  else
	    render json: {message:"not saved"}
	  end
	end

	def edit
	   @article = Article.find(params[:id])
	end

	def update
	   @article = Article.find(params[:id])

	  if @article.update(article_params)
	    render json: @article
	  else
	    render json: {message:"not updated"}
	  end
	end

	def destroy
    @article = Article.find(params[:id])
    @article.destroy
    render json: {message:"destroy succesfully"}
  end

  private
  def article_params
    params.require(:article).permit(:title, :body, :status, :user_id)
  end
end
