require "prawn"
class UsersController < ApplicationController
	protect_from_forgery
	include ActionController::Live
	rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
	skip_before_action :verify_authenticity_token
	# http_basic_authenticate_with name: "sachin", password: "1234"
  # TOKEN = "topsecret"
  # before_action :authenticate
  
  def stream
    response.headers['Content-Type'] = 'text/event-stream'
    10.times {
      response.stream.write "hello world\n"
      sleep 1
    }
  ensure
    response.stream.close
  end

	def new
   user = User.new
   render json: user
  end

  def index
    user = User.all
    render json: user
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
    grant.endpoint_id = "Chatty:sachin:browser"
    grant
  end

  def create
    # Create message in Twilio (example)
    # token = get_token
    # grant = get_grant
    # token.add_grant(grant)
    # byebug
    # render json: {username: "sachin", token: token.to_jwt}
    # Define User Identity
    identity = current_user.email

    # Create Grant for Access Token
    grant = Twilio::JWT::AccessToken::ChatGrant.new
    grant.service_sid = "ISeee62d57c18049c49a11aba7414b193b"

    # Create an Access Token
    token = Twilio::JWT::AccessToken.new(
      "AC7b11a2ccf68289cb7a893d93c61164ad",
      "SK4272f68b087548de9a0fd450cc79f044",
      "TlhDzFV3TuoptJUbrIFuxFYNMPzoQNmM",
      [grant],
      identity: identity
    )

    # Generate the token and send to client
    render json: { identity: identity, token: token.to_jwt }
  end

  # def create
  #   user = User.new(user_info)
  #   if user.save
  #     render json: user
  #   else
  #     render json: {message: "not saved"}
  #   end
  # end

  def update
	  user = User.find(params[:id])

	  if user.update(user_info)
	    render json: {data: user, message:"update succesfully"}
	  else
	    render json: {message:"error occured"}
	  end
	end

	def show
	  user = User.find_by_id(params[:id])
	  if user
	    render json: user
    else
    	render json: {message: "data not found"}
    end
	end

	def delete
    user = User.find(params[:id])
    user.destroy
    render json: {message: "delete a user"}
  end

  def download_pdf
    user = User.find(params[:id])
    send_data generate_pdf(user),
    filename: "#{user.name}.pdf",
    type: "application/pdf"
  end

  # def download_pdf
  #   user = User.find(params[:id])
  #   send_file("#{Rails.root}/#{user.id}.pdf",
  #   filename: "#{user.name}.pdf",
  #   type: "application/pdf")
  # end

  private
  def user_info
    params.permit(:name,:age,:address)
  end
  
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
    end
  end

  def generate_pdf(user)
    Prawn::Document.new do
      text user.name, align: :center
      text "Address: #{user.address}"
      text "Age: #{user.age}"
    end.render
  end

  def record_not_found
      render plain: "404 Not Found", status: 404
    end
end
