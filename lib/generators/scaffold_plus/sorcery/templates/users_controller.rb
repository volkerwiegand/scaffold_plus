class <%= controller_name.camelize %> < ApplicationController
  skip_before_action :require_login, only: [:log_in, :access, :password, :reset, :change, :refresh, :log_out]
  before_action :set_<%= name %>, only: [:show, :edit, :update, :destroy]

  # GET /<%= table_name %>
  # GET /<%= table_name %>.json
  def index
    @<%= table_name %> = <%= class_name %>.order(:email)
  end

  # GET /<%= table_name %>/1
  # GET /<%= table_name %>/1.json
  def show
  end

  # GET /<%= table_name %>/new
  def new
    @<%= name %> = <%= class_name %>.new
  end

  # POST /<%= table_name %>
  # POST /<%= table_name %>.json
  def create
    @<%= name %> = <%= class_name %>.new(<%= name %>_params)

    respond_to do |format|
      if @<%= name %>.save
        format.html { redirect_to @<%= name %>, notice: t('results.created', name: t('activerecord.models.<%= name %>.one')) }
        format.json { render :show, status: :created, location: @<%= name %> }
      else
        format.html { render :new }
        format.json { render json: @<%= name %>.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /<%= table_name %>/1/edit
  def edit
  end

  # PATCH/PUT /<%= table_name %>/1
  # PATCH/PUT /<%= table_name %>/1.json
  def update
    respond_to do |format|
      if @<%= name %>.update(<%= name %>_params)
        format.html { redirect_to @<%= name %>, notice: t('results.updated', name: t('activerecord.models.<%= name %>.one')) }
        format.json { render :show, status: :ok, location: @<%= name %> }
      else
        format.html { render :edit }
        format.json { render json: @<%= name %>.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /<%= table_name %>/log_in
  def log_in
    @<%= name %> = <%= class_name %>.new
    render layout: '<%= options.layout %>'
  end

  # POST /<%= table_name %>/access
  def access
    @<%= name %> = <%= class_name %>.find_by email: params[:<%= name %>][:email]
    if @<%= name %>.present? and @<%= name %>.active
<%- if options.remember_me? -%>
      @<%= name %> = login(params[:<%= name %>][:email], params[:<%= name %>][:password], params[:<%= name %>][:remember_me])
<%- else -%>
      @<%= name %> = login(params[:<%= name %>][:email], params[:<%= name %>][:password])
<%- end -%>
    else
      @<%= name %> = nil
    end
    if @<%= name %>.present?
      redirect_back_or_to root_path, notice: t('sorcery.success')
    else
      redirect_to log_in_users_path, alert: t('sorcery.failed')
    end
  end
<%- if options.reset_password? -%>

  # GET /<%= table_name %>/password
  def password
    @<%= name %> = <%= class_name %>.new
    render layout: '<%= options.layout %>'
  end

  # POST /<%= table_name %>/reset
  def reset
    if params[:<%= name %>][:email].present?
      @<%= name %> = <%= class_name %>.find_by email: params[:<%= name %>][:email]
      @<%= name %>.deliver_reset_password_instructions! if @<%= name %>
      redirect_to log_in_<%= table_name %>_path, notice: t('sorcery.reset.delivered')
    else
      redirect_to log_in_<%= table_name %>_path, alert: t('sorcery.reset.missing')
    end
  end

  # GET /<%= table_name %>/token/change
  def change
    @<%= name %> = <%= class_name %>.load_from_reset_password_token(params[:id])
    @token = params[:id]
    if @<%= name %>.blank?
      not_authenticated
      return
    end
    render layout: '<%= options.layout %>'
  end

  # PATCH/PUT /<%= table_name %>/token/refresh
  def refresh
    @token = params[:<%= name %>][:reset_password_token]
    @<%= name %> = <%= class_name %>.load_from_reset_password_token(@token)
    if @<%= name %>.blank?
      not_authenticated
      return
    end
    @<%= name %>.password_confirmation = params[:<%= name %>][:password_confirmation]
    if @<%= name %>.change_password!(params[:<%= name %>][:password])
      redirect_to root_path, notice: t('sorcery.reset.success')
    else
      redirect_to change_<%= name %>_path(@token), alert: t('sorcery.reset.failed')
    end
  end
<%- end -%>

  # DELETE /<%= table_name %>/1
  # DELETE /<%= table_name %>/1.json
  def destroy
    if @<%= name %> == current_<%= name %> or !current_<%= name %>.sysadm
      redirect_to root_path, alert: t('sorcery.forbidden')
      return
    end
    @<%= name %>.destroy
    respond_to do |format|
      format.html { redirect_to <%= table_name %>_url, notice: t('results.deleted', name: t('activerecord.models.<%= name %>.one')) }
      format.json { head :no_content }
    end
  end

  # GET /<%= table_name %>/log_out
  def log_out
    logout
    redirect_to root_url, notice: t('sorcery.goodbye')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= name %>
      @<%= name %> = <%= class_name %>.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def <%= name %>_params
      params.require(:<%= name %>).permit(<%= whitelist %>)
    end
end
