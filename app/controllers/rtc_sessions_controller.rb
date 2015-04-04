class RTCSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rtc_session, only: [:show, :edit, :update, :destroy]

  # GET /rtc_sessions
  # GET /rtc_sessions.json
  def index
    @rtc_sessions = RTCSession.all
  end

  # GET /rtc_sessions/1
  # GET /rtc_sessions/1.json
  def show
  end

  # GET /rtc_sessions/new
  def new
    @rtc_session = RTCSession.new
  end

  # GET /rtc_sessions/1/edit
  def edit
  end

  # POST /rtc_sessions
  # POST /rtc_sessions.json
  def create
    @rtc_session = RTCSession.new(rtc_session_params)

    respond_to do |format|
      if @rtc_session.save
        format.html { redirect_to @rtc_session, notice: 'RTC session was successfully created.' }
        format.json { render :show, status: :created, location: @rtc_session }
      else
        format.html { render :new }
        format.json { render json: @rtc_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rtc_sessions/1
  # PATCH/PUT /rtc_sessions/1.json
  def update
    respond_to do |format|
      if @rtc_session.update(rtc_session_params)
        format.html { redirect_to @rtc_session, notice: 'RTC session was successfully updated.' }
        format.json { render :show, status: :ok, location: @rtc_session }
      else
        format.html { render :edit }
        format.json { render json: @rtc_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rtc_sessions/1
  # DELETE /rtc_sessions/1.json
  def destroy
    @rtc_session.destroy
    respond_to do |format|
      format.html { redirect_to rtc_sessions_url, notice: 'RTC session was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rtc_session
      @rtc_session = RTCSession.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rtc_session_params
      params.require(:rtc_session).permit(:user_id, :sessionId, :started_at)
    end
end
