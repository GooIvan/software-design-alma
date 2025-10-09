class InvoicePdf < Prawn::Document
  def initialize(invoice)
    super(top_margin: 70)

    # Configurar para evitar warnings de UTF-8
    Prawn::Fonts::AFM.hide_m17n_warning = true

    @invoice = invoice
    @order = invoice.order
    @user = @order.user

    header
    invoice_details
    customer_details
    items_table
    totals
    footer
  end

  private

  def header
    # Logo y titulo (puedes agregar un logo si tienes uno)
    text "FACTURA", size: 30, style: :bold, align: :center
    move_down 10
    text "#{@invoice.formatted_invoice_number}", size: 16, align: :center, color: "666666"
    move_down 30

    # Informacion de la empresa
    bounding_box([0, cursor], width: 250, height: 100) do
      text "Diseños Alma", size: 14, style: :bold
      text "calle 123 #45-67"
      text "Barranquilla, Colombia"
      text "Telefono: 3022020011"
      text "Email: alma@designalma.com"
    end

    # Informacion de la factura
    bounding_box([300, cursor + 100], width: 250, height: 100) do
      text "Fecha de emision: #{@invoice.date.strftime("%d/%m/%Y")}", size: 11
      if @invoice.due_date
        text "Fecha de vencimiento: #{@invoice.due_date.strftime("%d/%m/%Y")}", size: 11
      end
      text "Estado: #{@invoice.status.humanize}", size: 11
      text "Orden relacionada: ##{@order.id}", size: 11
    end

    move_down 60
  end

  def invoice_details
    text "DETALLES DE FACTURACION", size: 14, style: :bold
    move_down 15
  end

  def customer_details
    # Información del cliente con mejor espaciado
    bounding_box([0, cursor], width: 280, height: 90) do
      text "FACTURAR A:", size: 12, style: :bold, color: "555555"
      move_down 8
      text "#{@user.name} #{@user.last_name}", size: 13, style: :bold, color: "333333"
      move_down 3
      text "#{@user.email}", size: 11, color: "666666"
      if @user.phone.present?
        move_down 2
        text "Tel: #{@user.phone}", size: 11, color: "666666"
      end
      if @user.address.present?
        move_down 2
        text "#{@user.address}", size: 11, color: "666666"
      end
      if @user.city.present?
        move_down 2
        text "#{@user.city}", size: 11, color: "666666"
      end
    end

    move_down 50 # Más espacio antes de la siguiente sección
  end

  def items_table
    text "PRODUCTOS", size: 14, style: :bold
    move_down 15 # Más espacio después del título

    table_data = [
      ["Producto", "Talla", "Cantidad", "Precio Unit.", "Total"],
    ]

    @order.order_items.each do |item|
      table_data << [
        item.product.name,
        item.size,
        item.quantity.to_s,
        format_currency(item.price),
        format_currency(item.price * item.quantity),
      ]
    end

    table(table_data, header: true, width: bounds.width) do
      row(0).font_style = :bold
      row(0).background_color = "F8F9FA"
      row(0).text_color = "333333"
      columns(2..4).align = :right
      self.cell_style = { 
        padding: [12, 15], 
        border_width: 0.5, 
        border_color: "DDDDDD",
        size: 11
      }
      self.header = true
    end

    move_down 25 # Más espacio después de la tabla
  end

  def totals
    move_down 10 # Agregar espacio antes de los totales
    
    # Tabla de totales
    totals_data = [
      ["Subtotal:", format_currency(@invoice.subtotal)],
      ["IVA (19%):", format_currency(@invoice.tax)],
      ["", ""],
      ["TOTAL:", format_currency(@invoice.total)],
    ]

    table(totals_data, position: :right, width: 200) do
      columns(0).align = :right
      columns(1).align = :right
      columns(1).font_style = :bold
      row(-1).font_style = :bold
      row(-1).font_size = 14
      row(-1).background_color = "F0F0F0"
      row(-2).border_width = 0
      self.cell_style = { padding: [8, 12], border_width: 0.5, border_color: "DDDDDD" }
    end

    move_down 40 # Más espacio antes del footer
  end

  def footer
    # Estado de pago con mejor posicionamiento
    move_down 20 # Espacio adicional antes del estado
    
    if @invoice.paid?
      bounding_box([0, cursor], width: bounds.width, height: 50) do
        fill_color "E8F5E8"
        fill_rectangle [0, 0], bounds.width, 50
        fill_color "000000"

        bounding_box([15, 35], width: bounds.width - 30) do
          text "✓ FACTURA PAGADA", size: 14, style: :bold, color: "2E7D32"
          move_down 5
          text "Esta factura ha sido pagada exitosamente.", size: 11, color: "2E7D32"
        end
      end
    else
      bounding_box([0, cursor], width: bounds.width, height: 50) do
        fill_color "FFF3E0"
        fill_rectangle [0, 0], bounds.width, 50
        fill_color "000000"

        bounding_box([15, 35], width: bounds.width - 30) do
          text "⚠ PENDIENTE DE PAGO", size: 14, style: :bold, color: "F57C00"
          move_down 5
          text "Esta factura está pendiente de pago.", size: 11, color: "F57C00"
        end
      end
    end

    move_down 70 # Más espacio después del estado

    # Pie de página mejorado
    bounding_box([0, 60], width: bounds.width) do
      stroke_horizontal_rule
      move_down 15
      text "Gracias por su compra con Diseños Alma",
           size: 12, align: :center, style: :bold, color: "333333"
      move_down 8
      text "Para cualquier consulta, contáctenos en alma@designalma.com o al 3022020011",
           size: 10, align: :center, color: "666666"
      move_down 5
      text "www.designalma.com",
           size: 9, align: :center, color: "999999"
    end
  end

  def format_currency(amount)
    "$#{sprintf("%.0f", amount).reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse}"
  end
end
