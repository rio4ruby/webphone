class AuthorizationsE911ContextsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_authorizations_e911_context, only: [:show, :edit, :update, :destroy]
  before_action :set_contexts, only: [:new, :edit, :update]
  
  # GET /authorizations_e911_contexts
  # GET /authorizations_e911_contexts.json
  def index
    @contexts = E911Context.for_user(current_user)
    @authorizations_e911_contexts = AuthorizationsE911Context.all
  end
  
  # GET /authorizations_e911_contexts/1
  # GET /authorizations_e911_contexts/1.json
  def show
  end

  # GET /authorizations_e911_contexts/new
  def new
    @authorization = Authorization.for_user(current_user).authorized.first
    @authorizations_e911_context = AuthorizationsE911Context.new(authorization_id: @authorization.id)
  end

  # GET /authorizations_e911_contexts/1/edit
  def edit
  end

  # POST /authorizations_e911_contexts
  # POST /authorizations_e911_contexts.json
  def create
    Rails.logger.info("PARAMS=#{params}")
    @authorizations_e911_context = AuthorizationsE911Context.new(authorizations_e911_context_params)

    respond_to do |format|
      if @authorizations_e911_context.save
        format.html { redirect_to pages_main_path, notice: 'Authorizations e911 context was successfully created.' }
        format.json { render :show, status: :created, location: @authorizations_e911_context }
      else
        format.html { render :new }
        format.json { render json: @authorizations_e911_context.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authorizations_e911_contexts/1
  # PATCH/PUT /authorizations_e911_contexts/1.json
  def update
    respond_to do |format|
      if @authorizations_e911_context.update(authorizations_e911_context_params)
        format.html { redirect_to @authorizations_e911_context, notice: 'Authorizations e911 context was successfully updated.' }
        format.json { render :show, status: :ok, location: @authorizations_e911_context }
      else
        format.html { render :edit }
        format.json { render json: @authorizations_e911_context.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authorizations_e911_contexts/1
  # DELETE /authorizations_e911_contexts/1.json
  def destroy
    @authorizations_e911_context.destroy
    respond_to do |format|
      format.html { redirect_to authorizations_e911_contexts_url, notice: 'Authorizations e911 context was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_contexts
    @contexts = E911Context.for_user(current_user)
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def set_authorizations_e911_context
    @authorizations_e911_context = AuthorizationsE911Context.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def authorizations_e911_context_params
    params.require(:authorizations_e911_context).permit(:authorization_id, :e911_context_id)
  end
end
