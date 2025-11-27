module Api
    class UsersController < BaseController
      def index
        users = User.all
        render json: users.map { |u| user_info(u) }
      end

      private

      def user_info(user)
        {
          id: user.id,
          name: user.respond_to?(:name) ? user.name : nil,
          email: user.email,
          created_at: user.created_at,
          updated_at: user.updated_at,
          role: user.respond_to?(:role) ? user.role : nil,
          phone: user.respond_to?(:phone) ? user.phone : nil,
          city: user.respond_to?(:city) ? user.city : nil,
          address: user.respond_to?(:address) ? user.address : nil
        }
      end
    end
end
