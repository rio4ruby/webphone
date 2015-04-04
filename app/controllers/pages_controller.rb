class PagesController < ApplicationController
  before_filter :authenticate_user!
  #before_action :set_page, only: [:show, :edit, :update, :destroy]

  # GET /pages/index
  def index
    puts "#{__method__.upcase} #{params}"
    @auth = current_user.authorizations.create!
  end

  # GET /pages/main
  def main
    puts "#{__method__.upcase} #{params}"
    @auth = current_user.authorizations.authorized.first
    @auth ||= current_user.authorizations.first
    @auth ||= current_user.authorizations.create
    if !(@auth.authorized? && @auth.has_e911id?)
      @contexts = E911Context.for_user(current_user)
      #render pages_main_path
    end
    unless @auth.has_e911id?
      @authorizations_e911_context = AuthorizationsE911Context.new(authorization_id: @auth.id)
      @e911_context = E911Context.new(user: current_user)
    end
  end

  def authorize

    puts "#{__method__.upcase} #{params}"
    @params = params
    id = params[:id].to_i
    user = User.where(id: id).first
    puts "ID=#{id} USER=#{user}"
    @auth = user.authorizations.create!
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }        
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params[:page]
    end
end
