# require "prawn"
class UsersController < ApplicationController
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
   @user = User.new
   render json: @user
  end

  def index
    @user = User.all
    render json: @user
  end

   def create
    @user = User.new(user_info)
    if @user.save
      render json: @user
    else
      # This line overrides the default rendering behavior, which
      # would have been to render the "create" view.
      render json: {message: "not saved"}
    end
  end

  def update
	  @user = User.find(params[:id])

	  if @user.update(user_info)
	    render json: {data: @user, message:"update succesfully"}
	  else
	    render json: {message:"error occured"}
	  end
	end

	def show
	  @user = User.find_by_id(params[:id])
	  # if @user
	    render json: @user
    # else
    # 	render json: {message: "data not found"}
    # end
	end

	def delete
    @user = User.find(params[:id])
    @user.destroy
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
