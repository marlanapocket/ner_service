class ApplicationController < ActionController::API

    before_action :authenticate_user!

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def not_found
        render json: {
          'errors': [
            {
              'status': '404',
              'title': 'Not Found'
            }
          ]
        }, status: 404
    end

    def render_jsonapi_response(resource)
        if resource.errors.empty?
            render jsonapi: resource
        else
            render jsonapi_errors: resource.errors, status: 400
        end
    end

end
