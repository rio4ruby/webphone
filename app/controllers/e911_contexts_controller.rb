class E911ContextsController < ApplicationController
  before_action :authenticate_user!, except: [:callback]

  before_action :set_e911_context, only: [:show, :edit, :update, :destroy]

  # GET /e911_contexts
  # GET /e911_contexts.json
  def index
    @e911_contexts = E911Context.all
  end

  # GET /e911_contexts/1
  # GET /e911_contexts/1.json
  def show
  end

  # GET /e911_contexts/new
  def new
    @e911_context = E911Context.new(user: current_user, isAddressConfirmed: false)
  end

  # GET /e911_contexts/1/edit
  def edit
  end

  # POST /e911_contexts
  # POST /e911_contexts.json
  def create
    puts "CREATE CREATE: #{e911_context_params}"
    @e911_context = E911Context.new(e911_context_params)

    respond_to do |format|
      if @e911_context.save
        format.html { redirect_to pages_main_path, notice: 'E911 context was successfully created.' }
        format.json { render :show, status: :created, location: @e911_context }
      else
        p @e911_context.errors.full_messages
        format.html { render :new }
        format.json { render json: @e911_context.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /e911_contexts/1
  # PATCH/PUT /e911_contexts/1.json
  def update
    respond_to do |format|
      if @e911_context.update(e911_context_params)
        format.html { redirect_to @e911_context, notice: 'E911 context was successfully updated.' }
        format.json { render :show, status: :ok, location: @e911_context }
      else
        format.html { render :edit }
        format.json { render json: @e911_context.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /e911_contexts/1
  # DELETE /e911_contexts/1.json
  def destroy
    @e911_context.destroy
    respond_to do |format|
      format.html { redirect_to e911_contexts_url, notice: 'E911 context was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_e911_context
      @e911_context = E911Context.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def e911_context_params
      p params
      params.require(:e911_context).permit(:user_id, :e911id, :name, :houseNumber, :houseNumExt, :streetDir, :streetDirSuffix, :street, :streetNameSuffix, :unit, :city, :state, :zip, :addressAdditional, :comments, :isAddressConfirmed)
    end
end
