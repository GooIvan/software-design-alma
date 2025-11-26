module Api
    class DashboardController < BaseController
      def index
        render json: {
          active_users_count: User.count,
          paid_orders_count: Order.where(status: 'paid').count,
          total_pending_orders: Order.where(status: 'pending').count,
            total_revenue: Order.where(status: 'paid').sum(:total).to_f,
          popular_categories: popular_categories,
          top_products: top_products,
          orders_per_month: orders_per_month,
          low_stock_products: low_stock_products
        }
      end

      private

      def popular_categories
        Category.joins(products: :order_items)
                .select('categories.*, SUM(order_items.quantity) as sold_count')
                .group('categories.id')
                .order('sold_count DESC')
                .limit(5)
                .map do |c|
                  {
                    name: c.as_json.merge(
                      'image_url' => c.image.attached? ? url_for(c.image) : nil
                    ),
                    sold_count: c.sold_count.to_i
                  }
                end
      end

      def top_products
        Product.joins(:order_items)
               .select('products.*, SUM(order_items.quantity) as sold_count')
               .group('products.id')
               .order('sold_count DESC')
               .limit(5)
               .map do |p|
                 p.as_json.merge(
                   'sold_count' => p.sold_count.to_i,
                   'image_url' => p.images.attached? ? url_for(p.images.first) : nil
                 )
               end
      end

      def orders_per_month
        Order.where(status: 'paid')
             .group("strftime('%Y-%m', created_at)")
             .count
             .map { |month, count| { month: month, count: count } }
      end

      def low_stock_products
        Product.where('stock < ?', 5).map do |p|
          p.as_json.merge(
            'image_url' => p.images.attached? ? url_for(p.images.first) : nil
          )
        end
      end
    end
end
