<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"
<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_filter :authenticate_user!
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  # GET <%= route_url %>
  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>
    authorize <%= class_name %>
  end
  # GET <%= route_url %>/1
  def show
    authorize @<%= singular_table_name %>
    add_breadcrumb @<%= singular_table_name %>.name, <%= singular_table_name %>_path(@<%= singular_table_name %>)
  end

  # GET <%= route_url %>/new
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    authorize @<%= singular_table_name %>
    add_breadcrumb t("common.new")
  end

  # GET <%= route_url %>/1/edit
  def edit
    authorize @<%= singular_table_name %>
    add_breadcrumb @<%= singular_table_name %>.name
  end

  # POST <%= route_url %>
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
    authorize @<%= singular_table_name %>
    if @<%= orm_instance.save %>
      redirect_to @<%= singular_table_name %>, notice: <%= "t('#{human_name.downcase.gsub(" ", "_")}.created')" %>
    else
      render :new
    end
  end
  # PATCH/PUT <%= route_url %>/1
  def update
    authorize @<%= singular_table_name %>
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      redirect_to @<%= singular_table_name %>, notice: <%= "t('#{human_name.downcase.gsub(" ", "_")}.updated')" %>
    else
      render :edit
    end
  end
  # DELETE <%= route_url %>/1
  def destroy
    authorize @<%= singular_table_name %>
    @<%= orm_instance.destroy %>
    redirect_to <%= index_helper %>_url, notice: <%= "t('#{human_name.downcase.gsub(" ", "_")}.destroyed')" %>
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params[:<%= singular_table_name %>]
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end
end
<% end -%>