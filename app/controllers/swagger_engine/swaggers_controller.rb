require_dependency "swagger_engine/application_controller"

module SwaggerEngine
  class SwaggersController < ApplicationController
    layout false

    def index
      redirect_to swagger_path(json_files.first[0]) if ( json_files.size == 1 )
    end

    def show
      respond_to do |format|
        format.html {
          if json_file[0] == '/'
            @swagger_json_url = json_file
          else
            @swagger_json_url = swagger_path(params[:id], format: :json)
          end
        }
        format.json {
          send_file json_file, type: 'application/json', disposition: 'inline'
        }
      end
    end

    private

    def json_file
      @json_file ||= json_files[params[:id].to_sym]
    end

    def json_files
      @json_files ||= SwaggerEngine.configuration.json_files || { default: "#{Rails.root}/lib/swagger_engine/swagger.json" }
    end
  end
end
