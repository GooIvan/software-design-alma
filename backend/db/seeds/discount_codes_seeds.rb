# Seeds para códigos de descuento públicos
# Ejecutar con: rails runner db/seeds/discount_codes_seeds.rb

puts "🎁 Creando códigos de descuento de ejemplo..."

discount_codes = [
  {
    code: "BIENVENIDO10",
    discount_type: "percentage",
    value: 10,
    description: "¡Bienvenido! 10% de descuento en tu primera compra",
    active: true,
    expires_at: 3.months.from_now,
    max_uses: 100,
    max_uses_per_user: 1
  },
  {
    code: "VERANO2024",
    discount_type: "percentage",
    value: 15,
    description: "Ofertas de verano - 15% en toda la tienda",
    active: true,
    expires_at: 2.months.from_now,
    max_uses: 50
  },
  {
    code: "ENVIOGRATIS",
    discount_type: "fixed",
    value: 15000,
    description: "Descuento equivalente al envío estándar",
    active: true,
    expires_at: nil, # Sin expiración
    max_uses: nil # Ilimitado
  },
  {
    code: "BLACKFRIDAY",
    discount_type: "percentage",
    value: 25,
    description: "Black Friday - ¡Hasta 25% de descuento!",
    active: true,
    expires_at: 1.week.from_now,
    max_uses: 200
  },
  {
    code: "DESCUENTO50K",
    discount_type: "fixed",
    value: 50000,
    description: "$50.000 de descuento en compras mayores a $200.000",
    active: true,
    expires_at: 1.month.from_now,
    max_uses: 30,
    max_uses_per_user: 1
  }
]

discount_codes.each do |dc_attrs|
  discount_code = DiscountCode.find_or_initialize_by(code: dc_attrs[:code])
  
  if discount_code.new_record?
    discount_code.assign_attributes(dc_attrs)
    if discount_code.save
      puts "  ✅ Código creado: #{discount_code.code} (#{discount_code.discount_type}: #{discount_code.value})"
    else
      puts "  ❌ Error al crear #{dc_attrs[:code]}: #{discount_code.errors.full_messages.join(', ')}"
    end
  else
    puts "  ⏭️  Código ya existe: #{discount_code.code}"
  end
end

puts "\n✨ ¡Códigos de descuento creados exitosamente!"
puts "📊 Total de códigos activos: #{DiscountCode.where(active: true, user_id: nil).count}"
