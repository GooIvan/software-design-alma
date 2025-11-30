# 🎁 Página de Ofertas y Promociones

## 📋 Descripción

Nueva página que reemplaza "Personaliza tu combo" con una sección completa de ofertas y promociones que incluye:

- ✅ **Códigos de descuento activos** - Muestra todos los códigos públicos disponibles
- ✅ **Productos más vendidos** - Basado en las ventas reales
- ✅ **Productos destacados** - Selección aleatoria de categorías populares
- ✅ **Recién llegados** - Productos agregados en los últimos 2 meses

## 🚀 Implementación

### Archivos creados:
1. `app/controllers/promotions_controller.rb` - Controlador principal
2. `app/views/promotions/index.html.erb` - Vista con todas las secciones
3. `db/seeds/discount_codes_seeds.rb` - Seeds para códigos de ejemplo

### Archivos modificados:
1. `config/routes.rb` - Agregadas rutas `/promotions` y `/customize`
2. `config/locales/es.yml` - Traducciones en español
3. `config/locales/en.yml` - Traducciones en inglés

## 📦 Instalación

### 1. Crear códigos de descuento de ejemplo (opcional)

```bash
docker-compose exec web rails runner db/seeds/discount_codes_seeds.rb
```

Esto creará 5 códigos de descuento públicos:
- `BIENVENIDO10` - 10% descuento (primera compra)
- `VERANO2024` - 15% descuento
- `ENVIOGRATIS` - $15.000 descuento fijo
- `BLACKFRIDAY` - 25% descuento
- `DESCUENTO50K` - $50.000 descuento fijo

### 2. Reiniciar el servidor (si es necesario)

```bash
docker-compose restart web
```

### 3. Acceder a la página

Visita: `http://localhost:3000/promotions` o `http://localhost:3000/customize`

O haz clic en **"Ofertas y Promociones"** en el navbar.

## 🎨 Características

### Copiar códigos al portapapeles
- Click en el botón de clipboard junto a cada código
- Se copiará automáticamente al portapapeles
- Feedback visual cuando se copia

### Diseño responsive
- Adaptado para móviles, tablets y desktop
- Cards con hover effects
- Badges coloridos para identificar tipos de descuento

### Traducciones
- Español e inglés incluidos
- Fácil de extender a más idiomas

## 🔧 Personalización

### Cambiar productos destacados
Edita el controlador `app/controllers/promotions_controller.rb`:

```ruby
@featured_products = Product.joins(:category)
                           .where(categories: { slug: ['tu-categoria'] })
                           .order('RANDOM()')
                           .limit(8)
```

### Agregar más códigos de descuento
Desde el admin panel:
`http://localhost:3000/admin/discount_codes/new`

O editando el archivo seeds.

## 📱 Integración con Flutter

La página está lista para ser consumida desde la app móvil. Los códigos de descuento se pueden validar usando el endpoint existente:

```
POST /api/discount_codes/validate
```

## ✨ Próximas mejoras sugeridas

- [ ] Filtros por categoría en productos destacados
- [ ] Carrusel automático de ofertas
- [ ] Contador regresivo para ofertas limitadas
- [ ] Notificaciones push cuando haya nuevas ofertas
- [ ] Wishlist de productos en oferta

---

**Creado el:** 30 de noviembre de 2025
**Versión:** 1.0
