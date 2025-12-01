# Crear usuario administrador
user = User.find_or_create_by!(email: "alma@designalma.com") do |user|
  user.password = "admin123"
  user.password_confirmation = "admin123"
  user.name = "Alma"
  user.last_name = "Empresa"
  user.phone = 3193291758
  user.city = "Barranquilla"
  user.address = "Calle 32 #45-67"
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
      name: "Camiseta selección colombia",
      description: "Camiseta de la selección colombiana de fútbol, confeccionada en 100% algodón de alta calidad, suave al tacto y resistente al uso diario. Su diseño clásico y cómodo la convierte en una prenda versátil, perfecta para cualquier ocasión y combina fácilmente con cualquier estilo.",
      price: 100000,
      stock: 3,
      sizes: ["XS", "S", "M", "L", "XL"],
      images: ["seeds/images/products/camiseta_colombia.webp"]
    },
    {
      name: "Camiseta oversize negra",
      description: "Camiseta negra confeccionada en 100% algodón de alta calidad, suave al tacto y resistente al uso diario. Su diseño clásico y cómodo la convierte en una prenda versátil, perfecta para cualquier ocasión y combina fácilmente con cualquier estilo.",
      price: 70000,
      stock: 3,
      sizes: ["XS", "S", "M", "L", "XL"],
      images: ["seeds/images/products/camiseta_negra.webp"]
    },
    {
      name: "Camiseta cantante",
      description: "Camiseta con diseño de cantante, confeccionada en 100% algodón de alta calidad, suave al tacto y resistente al uso diario. Su diseño clásico y cómodo la convierte en una prenda versátil, perfecta para cualquier ocasión y combina fácilmente con cualquier estilo.",
      price: 70000,
      stock: 3,
      sizes: ["XS", "S", "M", "L", "XL"],
      images: ["seeds/images/products/camiseta_anuel.webp", "seeds/images/products/camiseta_anuel_2.jpg"]
    },
    {
      name: "Camiseta azul",
      description: "Camiseta azul confeccionada en 100% algodón de alta calidad, suave al tacto y resistente al uso diario. Su diseño clásico y cómodo la convierte en una prenda versátil, perfecta para cualquier ocasión y combina fácilmente con cualquier estilo.",
      price: 60000,
      stock: 20,
      sizes: ["XS","S", "L", "XL"],
      images: ["seeds/images/products/camiseta_azul.jpg", "seeds/images/products/camiseta_azul_2.webp"]
    },
    {
      name: "Camiseta blanca",
      description: "Camiseta blanca confeccionada en 100% algodón de alta calidad, suave al tacto y resistente al uso diario. Su diseño clásico y cómodo la convierte en una prenda versátil, perfecta para cualquier ocasión y combina fácilmente con cualquier estilo.",
      price: 5500,
      stock: 0,
      sizes: ["XS","S", "M", "XL"],
      images: ["seeds/images/products/Camiseta_Blanca_Clasica.webp"]
    },
    {
      name: "Camiseta oversize verde",
      description: "Camiseta verde confeccionada en 100% algodón de alta calidad, suave al tacto y resistente al uso diario. Su diseño clásico y cómodo la convierte en una prenda versátil, perfecta para cualquier ocasión y combina fácilmente con cualquier estilo.",
      price: 70000,
      stock: 1,
      sizes: ["XS","S", "M", "L", "XL"],
      images: ["seeds/images/products/Camiseta_Overside_Estilo_Urbano.webp"]
    }
   ]
  },
  {
    name: "Tazas",
    image: "seeds/images/categories/tazas.webp",
    products: [
    {
      name: "Taza personalizada",
      description: "Taza personalizada con tu diseño, fabricada en cerámica de alta calidad y pensada para durar. Su impresión nítida y resistente garantiza que tu arte, frase o logo luzca impecable día tras día. Ideal para regalar, usar en la oficina o disfrutar tu bebida favorita con estilo y un toque totalmente único.",
      price: 20000,
      stock: 40,
      sizes: ["MEDIUM", "BIG"],
      images: ["seeds/images/products/product_taza.webp"]
    },
    {
      name: "Taza mágica negra",
      description: "Taza mágica negra, atrevida, fabricada en cerámica de alta calidad y pensada para durar. Su impresión nítida y resistente garantiza que luzca impecable día tras día. Ideal para regalar, usar en la oficina o disfrutar tu bebida favorita con estilo y un toque totalmente único.",
      price: 25000,
      stock: 30,
      sizes: ["MEDIUM", "SMALL"],
      images: ["seeds/images/products/Taza_Magica_Negra.webp"]
    },
    {
      name: "Taza dia feliz",
      description: "Taza con diseño motivador para empezar el día con energía positiva, fabricada en cerámica de alta calidad y pensada para durar. Su impresión nítida y resistente garantiza que luzca impecable día tras día. Ideal para regalar, usar en la oficina o disfrutar tu bebida favorita con estilo y un toque totalmente único.",
      price: 20000,
      stock: 0,
      sizes: ["MEDIUM", "BIG"],
      images: ["seeds/images/products/Taza_Con_Frase_Motivadora.webp"]
    },
    {
      name: "Taza Minimalista",
      description: "Taza minimalista blanca, elegante y sencilla, fabricada en cerámica de alta calidad y pensada para durar. Su impresión nítida y resistente garantiza que luzca impecable día tras día. Ideal para regalar, usar en la oficina o disfrutar tu bebida favorita con estilo y un toque totalmente único.",
      price: 18500,
      stock: 50,
      sizes: ["MEDIUM", "SMALL"],
      images: ["seeds/images/products/Taza_minimalista_Blanca.webp"]
    }
   ]
  },
  {
    name: "Mousepads",
    image: "seeds/images/categories/mousepad.jpg",
    products: [
    {
      name: "Mousepad basico negro",
      description: "Mousepad básico negro, superficie suave y cómoda para un deslizamiento preciso del mouse. Fabricado con materiales duraderos y una base antideslizante que garantiza estabilidad en cualquier superficie. Ideal para uso en oficina, gaming o diseño, este mousepad combina funcionalidad y estilo en un accesorio esencial para tu espacio de trabajo.",
      price: 30000,
      stock: 20,
      sizes: ["MEDIUM"],
      images: ["seeds/images/products/product_mousepad.webp"]
    },
    {
      name: "Mousepad Gamer",
      description: "Mousepad gamer, superficie suave y cómoda para un deslizamiento preciso del mouse. Fabricado con materiales duraderos y una base antideslizante que garantiza estabilidad en cualquier superficie. Ideal para uso en gaming, este mousepad combina funcionalidad y estilo en un accesorio esencial para tu espacio de juego.",
      price: 55000,
      stock: 5,
      sizes: ["BIG"],
      images: ["seeds/images/products/Mousepad_Gamer_Personalizado.webp"]
    },
    {
      name: "Mousepad Negro",
      description: "Base de goma para mayor adherencia, superficie antideslizante y resistente al desgaste. Ideal para uso diario en oficina o gaming, este mousepad combina funcionalidad y estilo en un accesorio esencial para tu espacio de trabajo.",
      price: 30000,
      stock: 35,
      sizes: ["MEDIUM", "BIG"],
      images: ["seeds/images/products/Mousepad_Antideslizante.webp"]
    },
    {
      name: "Mousepad LED",
      description: "Mousepad con luces LED RGB, superficie suave y cómoda para un deslizamiento preciso del mouse. Fabricado con materiales duraderos y una base antideslizante que garantiza estabilidad en cualquier superficie. Ideal para uso en gaming, este mousepad combina funcionalidad y estilo en un accesorio esencial para tu espacio de juego.",
      price: 90000,
      stock: 30,
      sizes: ["MEDIUM", "BIG"],
      images: ["seeds/images/products/Mousepad_Con_LED_RGB.webp"]
    }
   ]
  },
  {
    name: "Fundas para Celular",
    image: "seeds/images/categories/fundas.jpeg",
    products: [
    {
      name: "Funda personalizada",
      description: "Funda personalizada para celular, diseñada para ofrecer protección y estilo únicos. Fabricada con materiales resistentes que protegen contra golpes, caídas y arañazos, esta funda se adapta perfectamente a tu dispositivo. Personalízala con tu diseño favorito, ya sea una foto, un patrón o un logo, para reflejar tu personalidad mientras mantienes tu celular seguro.",
      price: 18000,
      stock: 3,
      sizes: ["MEDIUM", "SMALL"],
      images: ["seeds/images/products/product_funda.webp"]
    },
    {
      name: "Funda de silicona",
      description: "Funda de silicona flexible y resistente, diseñada para ofrecer una protección ligera y eficaz a tu celular. Su material suave al tacto proporciona un agarre cómodo, mientras que su diseño delgado permite un fácil acceso a todos los botones y puertos del dispositivo. Disponible en varios colores vibrantes, esta funda combina funcionalidad y estilo para mantener tu celular seguro y con un aspecto moderno.",
      price: 12000,
      stock: 3,
      sizes: ["BIG", "MEDIUM", "SMALL"],
      images: ["seeds/images/products/fundas_colores.jpg"]
    },
    {
      name: "Funda Transparente",
      description: "Protección ligera que resalta el diseño original, con bordes reforzados para absorber impactos y evitar daños por caídas. Acceso completo a todos los botones y puertos del dispositivo.",
      price: 12000,
      stock: 45,
      sizes: ["BIG"],
      images: ["seeds/images/products/Funda_Transparente_Ultrafina.webp"]
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
      
      # Procesar múltiples imágenes
      if product_data[:images].present?
        product_data[:images].each do |image_path|
          product_image_path = Rails.root.join("db", image_path)
          
          if File.exist?(product_image_path)
            product.images.attach(
              io: File.open(product_image_path),
              filename: File.basename(product_image_path),
              content_type: "image/webp"
            )
          else
            puts "⚠️  Imagen de producto no encontrada: #{product_image_path}"
          end
        end
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


# 🏷️ Crear códigos de descuento
discount_codes_data = [
  { code: "DESCUENTO10", discount_type: "percentage", value: 10, max_uses: 100, max_uses_per_user: 2, starts_at: 1.month.ago, expires_at: 3.months.from_now, active: true },
  { code: "WELCOME20", discount_type: "percentage", value: 20, max_uses: 200, max_uses_per_user: 1, starts_at: 1.month.ago, expires_at: 6.months.from_now, active: true },
  { code: "BLACKFRIDAY", discount_type: "percentage", value: 50, max_uses: 20, max_uses_per_user: 1, starts_at: 1.day.ago, expires_at: 2.days.from_now, active: true },
]

discount_codes_data.each do |data|
  code = DiscountCode.find_or_initialize_by(code: data[:code])
  code.assign_attributes(data)
  if code.save
    puts "🏷️  Código de descuento '#{code.code}' creado"
  else
    puts "❌ Error creando código #{code.code}: #{code.errors.full_messages.join(", ")}"
  end
end

# 🧪 Crear usuarios de prueba
test_users = [
  { name: "Andrw", last_name: "Martinez", email: "andrwm@gmail.com", password: "test1234", password_confirmation: "test1234", city: "Barranquilla", phone: 3128324457, address: "Calle 21 #23-4b", role: "customer"},
  { name: "Jesus", last_name: "Zambrano", email: "jesuszambrano123@hotmail.com", password: "test1234", password_confirmation: "test1234", city: "Soledad", phone: 3019833737, address: "Diag 51 tranvs 12b", role: "customer"},
  { name: "Jeison", last_name: "Torres", email: "jtorres@gmail.com", password: "test1234", password_confirmation: "test1234", city: "Bógota", phone: 3106941862, address: "Cra 76 #9", role: "customer"}
]

created_users = test_users.map do |data|
  user = User.find_or_initialize_by(email: data[:email])
  user.name = data[:name]
  user.last_name = data[:last_name]
  user.password = "test1234"
  user.password_confirmation = "test1234"
  user.city = data[:city]
  user.phone = data[:phone]
  user.address = data[:address]
  user.role = data[:role]
  user.save!
  user
end

# Generar una fecha aleatoria entre hace 6 meses y hace 1 mes
def random_past_date
  range_start = 6.months.ago.to_date
  range_end   = 1.month.ago.to_date
  Date.jd(rand(range_start.jd..range_end.jd))
end

created_users.first.update!(created_at: 1.month.from_now)

# 🧾 Generar órdenes antiguas

puts "🧾 Generando órdenes antiguas..."

# Asegurarse de que existan usuarios y productos
users = User.all
products = Product.all

if users.empty? || products.empty?
  puts "⚠️ No hay usuarios o productos para generar órdenes."
else
   20.times do
      user = users.sample
      status = ["pending", "paid", "cancelled"].sample
      order = Order.new(
        user: user,
        status: status,
        discount_amount: 0,
        created_at: rand(2..6).months.ago
      )

      # Solo productos con stock > 0
      available_products = products.select { |p| p.stock.to_i > 0 }
      next if available_products.empty?

      items_count = rand(1..3)
      items_added = 0

      items_count.times do
        product = available_products.sample
        next unless product && product.stock.to_i > 0

        quantity = rand(1..[3, product.stock].min)
        order.order_items.build(
          product: product,
          price: product.price,
          quantity: quantity,
          size: product.sizes&.sample
        )
        items_added += 1
        # Evitar repetir el mismo producto en la misma orden
        available_products.delete(product)
        break if available_products.empty?
      end

      next if items_added == 0 # No se pudo agregar ningún item válido

      order.calculate_total_without_discount
      order.save!
      puts "🧾 Orden ##{order.id} creada (#{order.status}) con total #{order.total}"
    end
end
