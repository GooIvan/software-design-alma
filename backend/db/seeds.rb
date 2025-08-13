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
  user.phone = 131313131
  user.city = "Barranquilla"
  user.address = "Calle 123"
  user.phone = 123456789
  user.role = "admin"
end

user.save if user.changed?

# Categorías con productos únicos por cada una
categories = [
  {
    name: "Camisetas",
    image: "seeds/images/categories/camisetas.webp",
    products: [
    {
      name: "Camiseta Diseño Único",
      description: "Camiseta 100% algodón con estampado exclusivo.",
      price: 40000,
      stock: 30,
      sizes: ["XS", "S", "M", "L", "XL"],
      image: "seeds/images/products/product_camiseta.webp"
    },
    {
      name: "Camiseta Negra",
      description: "Diseño exclusivo para eventos.",
      price: 45000,
      stock: 20,
      sizes: ["XS","S","M", "L", "XL"],
      image: "seeds/images/products/Camiseta_Negra_Edicion_Limitada.webp"
    },
    {
      name: "Camiseta Blanca",
      description: "Camiseta básica blanca de alta calidad.",
      price: 35000,
      stock: 25,
      sizes: ["XS","S", "M", "L", "XL"],
      image: "seeds/images/products/Camiseta_Blanca_Clasica.webp"
    },
    {
      name: "Camiseta Verde",
      description: "Camiseta Overside verde de alta calidad.",
      price: 20000,
      stock: 15,
      sizes: ["XS","S", "M", "L", "XL"],
      image: "seeds/images/products/Camiseta_Overside_Estilo_Urbano.webp"
    }
   ]
  },
  {
    name: "Tazas",
    image: "seeds/images/categories/tazas.webp",
    products: [
    {
      name: "Taza Personalizada",
      description: "Taza personalizada con tu diseño.",
      price: 20000,
      stock: 40,
      sizes: ["MEDIUM", "BIG"],
      image: "seeds/images/products/product_taza.webp"
    },
    {
      name: "Taza mágica negra",
      description: "Taza que revela tu diseño con calor.",
      price: 25000,
      stock: 30,
      sizes: ["MEDIUM", "SMALL"],
      image: "seeds/images/products/Taza_Magica_Negra.webp"
    },
    {
      name: "Taza con frase",
      description: "Ideal para iniciar tu día con buena energía.",
      price: 18000,
      stock: 60,
      sizes: ["MEDIUM", "BIG"],
      image: "seeds/images/products/Taza_Con_Frase_Motivadora.webp"
    },
    {
      name: "Taza Minimalista",
      description: "Ideal taza minimalista con un diseño blanco simple",
      price: 18500,
      stock: 50,
      sizes: ["MEDIUM", "SMALL"],
      image: "seeds/images/products/Taza_minimalista_Blanca.webp"
    }
   ]
  },
  {
    name: "Mousepads",
    image: "seeds/images/categories/mousepads.webp",
    products: [
    {
      name: "Mousepad Basico",
      description: "Mousepad de gran tamaño, color negro básico",
      price: 30000,
      stock: 20,
      sizes: ["MEDIUM", "BIG"],
      image: "seeds/images/products/product_mousepad.webp"
    },
    {
      name: "Mousepad Gamer",
      description: "Superficie optimizada para precisión.",
      price: 18000,
      stock: 50,
      sizes: ["MEDIUM", "BIG"],
      image: "seeds/images/products/Mousepad_Gamer_Personalizado.webp"
    },
    {
      name: "Mousepad Negro",
      description: "Base de goma para mayor adherencia.",
      price: 22000,
      stock: 35,
      sizes: ["MEDIUM", "BIG"],
      image: "seeds/images/products/Mousepad_Antideslizante.webp"
    }
   ]
  },
  {
    name: "Fundas para Celular",
    image: "seeds/images/categories/fundas.webp",
    products: [
    {
      name: "Funda Antigolpes",
      description: "Funda resistente con diseño moderno.",
      price: 15000,
      stock: 50,
      sizes: ["MEDIUM", "BIG"],
      image: "seeds/images/products/product_funda.webp"
    },
    {
      name: "Funda Samsung",
      description: "Estilo y protección para tu Galaxy.",
      price: 21000,
      stock: 35,
      sizes: ["M", "L"],
      image: "seeds/images/products/Funda_Samsung_Galaxy_Diseño.webp"
    },
    {
      name: "Funda Transparente",
      description: "Protección discreta y elegante.",
      price: 12000,
      stock: 45,
      sizes: ["M", "L"],
      image: "seeds/images/products/Funda_Transparente_Ultrafina.webp"
    }
   ]
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

    # 🧹 Eliminar productos antiguos antes de crear nuevos
    category.products.destroy_all

    data[:products].each do |product_data|
      product = category.products.find_or_initialize_by(name: product_data[:name])
      product.description = product_data[:description]
      product.price = product_data[:price]
      product.stock = product_data[:stock]
      product.sizes = product_data[:sizes]
      product_image_path = Rails.root.join("db", product_data[:image])

      if File.exist?(product_image_path)
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
      else
        puts "❌ Error al crear producto: #{product.errors.full_messages.join(", ")}"
      end
    end
  else
    puts "❌ Error al crear categoría '#{category.name}': #{category.errors.full_messages.join(", ")}"
  end
end


# 🧪 Crear usuarios de prueba
test_users = [
  { name: "Juan", last_name: "Pérez", email: "juan@example.com", password: "test1234", password_confirmation: "test1234", city: "Ciudad", phone: 123456789, address: "Dirección 123", role: "customer"},
  { name: "Ana", last_name: "Gómez", email: "ana@example.com", password: "test1234", password_confirmation: "test1234", city: "Ciudad", phone: 123456789, address: "Dirección 123", role: "customer"},
  { name: "Luis", last_name: "Torres", email: "luis@example.com", password: "test1234", password_confirmation: "test1234", city: "Ciudad", phone: 123456789, address: "Dirección 123", role: "customer"}
]

created_users = test_users.map do |data|
  user = User.find_or_initialize_by(email: data[:email])
  user.name = data[:name]
  user.last_name = data[:last_name]
  user.password = "test1234"
  user.password_confirmation = "test1234"
  user.city = "Ciudad"
  user.phone = data[:phone]
  user.address = "Dirección 123"
  user.role = "customer"
  user.save!
  user
end

# 📅 Modificar created_at del primer usuario
created_users.first.update!(created_at: 1.month.from_now)
 
# rake db:seed