namespace :db do
  desc "Elimina todos los registros en desarrollo respetando relaciones y claves foráneas"
  task reset_development: :environment do
    puts "🔁 Desactivando claves foráneas..."
    ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = OFF;")

    puts "🗑️ Eliminando registros..."
    CartItem.delete_all
    Cart.delete_all
    Product.delete_all
    Category.delete_all
    User.delete_all
    HomeVideo.delete_all

    puts "✅ Registros eliminados."

    puts "🔒 Reactivando claves foráneas..."
    ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = ON;")
  end
end