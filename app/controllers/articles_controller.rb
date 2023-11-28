class ArticlesController < ApplicationController
	# skip_before_action :verify_authenticity_token
	# http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]
	require "twilio-ruby"
	def index
	end

  def get_token
    Twilio::JWT::AccessToken.new(
      Twilio.account_sid,
      Twilio.auth_token,
      3600
    )
  end

  def get_grant 
	  grant = Twilio::JWT::AccessToken::ChatGrant.new 
	  grant.endpoint_id = "Chatty:#{current_user.name}:browser"
	  grant
  end

  def create
    # Create message in Twilio (example)
    token = get_token
    grant = get_grant
    token.add_grant(grant)
    render json: {username: current_user.name, token: token.to_jwt}
  end

  def reply
    @messages = Twilio::TwiML::MessagingResponse.new
    content_type 'text/xml'
    @messages.to_s
    render :index
  end

	def show
	  article = Article.find_by_id(params[:id])
	  if article
	   render json: article
	 else
	 	 render json: { message: "data not found" }
	 end
	end

	def new
	  article = Article.new
	end

	# def create
	#   article = Article.new(article_params)

	#   if article.save
	#   	flash[:notice] = "Thanks For The Article"
	#     render json: article
	#   else
	#     render json: {message:"not saved"}
	#   end
	# end

	def edit
	   article = Article.find(params[:id])
	end

	def update
	   article = Article.find(params[:id])

	  if article.update(article_params)
	    render json: article
	  else
	    render json: {message:"not updated"}
	  end
	end

	def destroy
    article = Article.find(params[:id])
    article.destroy
    render json: {message:"destroy succesfully"}
  end

  private
  def article_params
    params.require(:article).permit(:title, :body, :status, :user_id)
  end
end
