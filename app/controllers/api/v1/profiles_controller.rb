module Api
  module V1
    class ProfilesController < BaseController
      def me
        render json: current_resource_owner, serializer: ProfileSerializer
      end

      def index
        profiles = User.where.not(id: current_resource_owner.id)
        render json: profiles, each_serializer: ProfileSerializer
      end
    end
  end
end
