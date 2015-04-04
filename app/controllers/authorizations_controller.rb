class AuthorizationsController < ApplicationController
  before_action :authenticate_user!, except: [:callback]

  before_action :set_authorization, only: [:show, :edit, :update, :destroy]

  def callback
    id = params[:state].to_i
    auth_code = params[:code]

    auth = Authorization.where(id: id).first
    if auth
      auth.update_attributes(auth_code: auth_code)
      auth.exchange_code
    end
    redirect_to pages_main_path
    #head :ok
  end



  # GET /authorizations/1/edit
  def edit
    id = params[:id].to_i
    @contexts = E911Context.for_user(current_user)
    @authorization = Authorization.where(id: id).first
  end

  # PATCH/PUT /authorizations/1
  # PATCH/PUT /authorizations/1.json
  def update
    p "UPDATE PARAMS: #{params}"

  end

  # GET /authorizations
  # GET /authorizations.json
  def index
    @authorizations = Authorization.all
  end

  # GET /authorizations/1
  # GET /authorizations/1.json
  def show
  end

  # GET /authorizations/new
  def new
    @authorization = Authorization.new(user: current_user)
  end


  # POST /authorizations
  # POST /authorizations.json
  def create
    @authorization = Authorization.new(authorization_params)

    respond_to do |format|
      if @authorization.save
        format.html { redirect_to @authorization, notice: 'Authorization was successfully created.' }
        format.json { render :show, status: :created, location: @authorization }
      else
        format.html { render :new }
        format.json { render json: @authorization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authorizations/1
  # DELETE /authorizations/1.json
  def destroy
    @authorization.destroy
    respond_to do |format|
      format.html { redirect_to authorizations_url, notice: 'Authorization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_authorization
      @authorization = Authorization.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def authorization_params
      params.require(:authorization).permit(:references, :carrier, :access_token, :refresh_token, :authorized_at, :e911id)
    end
end
