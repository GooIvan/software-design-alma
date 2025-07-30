# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Crear usuario administrador
user = User.find_or_create_by!(email: "alma@designalma.com") do |user|
  user.password = "admin123"
  user.password_confirmation = "admin123"
  user.name = "Alma"
  user.last_name = "Empresa"
  user.city = "Barranquilla"
  user.address = "Calle 123"
  user.role = "admin"
end

user.save if user.changed?

products = []

# Categorías con productos únicos por cada una
categories = [
  {
    name: "Camisetas",
    image: "seeds/images/categories/camisetas.webp",
    product: {
      name: "Camiseta Diseño Único",
      description: "Camiseta 100% algodón con estampado exclusivo.",
      price: 40000,
      stock: 30,
      sizes: ["XS", "S", "M", "L", "XL"],
      image: "seeds/images/products/product_camiseta.webp"
    }
  },
  {
    name: "Tazas",
    image: "seeds/images/categories/tazas.webp",
    product: {
      name: "Taza Personalizada",
      description: "Taza personalizada con tu diseño.",
      price: 20000,
      stock: 40,
      sizes: ["MEDIUM", "BIG"],
      image: "seeds/images/products/product_taza.webp"
    }
  },
  {
    name: "Mousepads",
    image: "seeds/images/categories/mousepads.webp",
    product: {
      name: "Mousepad Basico",
      description: "Mousepad de gran tamaño, color negro básico",
      price: 30000,
      stock: 20,
      sizes: ["MEDIUM", "BIG"],
      image: "seeds/images/products/product_mousepad.webp"
    }
  },
  {
    name: "Fundas para Celular",
    image: "seeds/images/categories/fundas.webp",
    product: {
      name: "Funda Antigolpes",
      description: "Funda resistente con diseño moderno.",
      price: 15000,
      stock: 50,
      sizes: ["MEDIUM", "BIG"],
      image: "seeds/images/products/product_funda.webp"
    }
  }
]

categories.each do |data|
  category = Category.find_or_initialize_by(name: data[:name])
  category_image_path = Rails.root.join("db", data[:image])

  if File.exist?(category_image_path)
    category.image.attach(
      io: File.open(category_image_path),
      filename: File.basename(category_image_path),
      content_type: "image/webp"
    )
  else
    puts "⚠️  Imagen de categoría no encontrada: #{category_image_path}"
  end

  if category.save
    puts "✅ Categoría '#{category.name}' creada con imagen"

    product_data = data[:product]
    product = category.products.find_or_initialize_by(name: product_data[:name])
    product.description = product_data[:description]
    product.price = product_data[:price]
    product.stock = product_data[:stock]
    product.sizes = product_data[:sizes] # 🟢 Asignamos las tallas
    product_image_path = Rails.root.join("db", product_data[:image])

    if File.exist?(product_image_path)
      unless product.image.attached?
      product.image.attach(
        io: File.open(product_image_path),
        filename: File.basename(product_image_path),
        content_type: "image/webp"
      )
    else
      puts "⚠️  Imagen de producto no encontrada: #{product_image_path}"
    end

    if product.save
      puts "🛒 Producto '#{product.name}' creado en categoría '#{category.name}'"
      products << product
    else
      puts "❌ Error al crear producto: #{product.errors.full_messages.join(", ")}"
    end
  else
    puts "❌ Error al crear categoría '#{category.name}': #{category.errors.full_messages.join(", ")}"
  end
end

# 🧪 Crear usuarios de prueba
test_users = [
  { name: "Juan", last_name: "Pérez", email: "juan@example.com" },
  { name: "Ana", last_name: "Gómez", email: "ana@example.com" },
  { name: "Luis", last_name: "Torres", email: "luis@example.com" }
]

created_users = test_users.map do |data|
  user = User.find_or_initialize_by(email: data[:email])
  user.name = data[:name]
  user.last_name = data[:last_name]
  user.password = "test1234"
  user.password_confirmation = "test1234"
  user.city = "Ciudad"
  user.address = "Dirección 123"
  user.role = "customer"
  user.save!
  user
end
  
# rake db:seed