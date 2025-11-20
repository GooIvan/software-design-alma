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
    # Logo y titulo
    begin
      logo_path = Rails.root.join("app", "assets", "images", "logo.png")

      if File.exist?(logo_path)
        # Agregar logo
        image logo_path, width: 100, position: :center
        move_down 15
      end
    rescue => e
      Rails.logger.warn "No se pudo cargar el logo: #{e.message}"
    end

    text "COMPROBANTE DE PAGO", size: 28, style: :bold, align: :center
    move_down 8
    text "#{@invoice.formatted_invoice_number}", size: 14, align: :center, color: "888888"
    move_down 25

    # Informacion de la empresa
    bounding_box([0, cursor], width: 250, height: 100) do
      text "Diseños Alma", size: 13, style: :bold, color: "333333"
      move_down 3
      text "calle 123 #45-67", size: 10, color: "666666"
      text "Barranquilla, Colombia", size: 10, color: "666666"
      text "Teléfono: 3022020011", size: 10, color: "666666"
      text "Email: alma@designalma.com", size: 10, color: "666666"
    end

    # Informacion de la factura
    bounding_box([300, cursor + 100], width: 250, height: 100) do
      text "Fecha de emisión: #{@invoice.date.strftime("%d/%m/%Y")}", size: 10, color: "333333"
      if @invoice.due_date
        text "Fecha de vencimiento: #{@invoice.due_date.strftime("%d/%m/%Y")}", size: 10, color: "333333"
      end
      text "Estado: #{@invoice.status.humanize}", size: 10, color: "333333"
      text "Orden relacionada: ##{@order.id}", size: 10, color: "333333"
    end

    move_down 50
  end

  def invoice_details
    text "DETALLES", size: 14, style: :bold
    move_down 15
  end

  def customer_details
    # Información del cliente
    bounding_box([0, cursor], width: 250, height: 80) do
      text "ENTREGAR A:", size: 10, style: :bold, color: "888888"
      move_down 8
      text "#{@user.name} #{@user.last_name}", size: 11, style: :bold, color: "333333"
      text "#{@user.email}", size: 9, color: "666666"
      text "#{@user.phone}", size: 9, color: "666666" if @user.phone.present?
      if @user.address.present?
        text "#{@user.address}", size: 9, color: "666666"
      end
      if @user.city.present?
        text "#{@user.city}", size: 9, color: "666666"
      end
    end

    move_down 35
  end

  def items_table
    text "PRODUCTOS", size: 13, style: :bold, color: "333333"
    move_down 12

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
      row(0).background_color = "E8E8E8"
      row(0).text_color = "333333"
      columns(2..4).align = :right
      self.cell_style = { padding: [10, 12], border_width: 1, border_color: "DDDDDD" }
      self.header = true
    end

    move_down 25
  end

  def totals
    # Calcular el subtotal original (antes del descuento)
    subtotal_before_discount = @order.order_items.sum { |item| item.price * item.quantity }
    
    # Obtener el descuento aplicado
    discount_amount = @order.discount_amount || 0
    if discount_amount == 0 && @order.discount_usage.present?
      discount_amount = @order.discount_usage.discount_amount
    end

    # Tabla de totales
    totals_data = [
      ["Subtotal:", format_currency(subtotal_before_discount)],
    ]

    # Agregar fila de descuento si existe
    discount_code_present = @order&.discount_code.present?
    if discount_code_present && discount_amount > 0
      totals_data << ["Descuento (#{@order.discount_code.code}):", "-#{format_currency(discount_amount)}"]
    end

    # Continuar con IVA y total
    totals_data << ["IVA (19%):", format_currency(@invoice.tax)]
    
    # Calcular el total final considerando el descuento
    final_total = subtotal_before_discount - discount_amount + @invoice.tax
    totals_data << ["TOTAL:", format_currency(final_total)]

    table(totals_data, position: :right, width: 220) do
      columns(0).align = :right
      columns(1).align = :right
      columns(1).font_style = :bold

      # Estilo para las filas normales
      rows(0..-2).each do |row|
        row.text_color = "666666"
      end

      # Estilo especial para el descuento si existe
      if discount_code_present && discount_amount > 0
        discount_row_index = discount_code_present ? 1 : -1
        if discount_row_index > 0
          row(discount_row_index).text_color = "4CAF50"
          row(discount_row_index).font_style = :bold
        end
      end

      # Estilo especial para el total
      row(-1).font_style = :bold
      row(-1).font_size = 13
      row(-1).background_color = "E8E8E8"
      row(-1).text_color = "333333"

      self.cell_style = { padding: [8, 12], border_width: 1, border_color: "DDDDDD" }
    end

    move_down 30
  end

  def footer
    # Estado de pago
    current_cursor = cursor

    if @invoice.paid?
      # Caja con borde para estado pagado
      bounding_box([0, current_cursor], width: bounds.width, height: 50) do
        stroke_bounds
        stroke_color "4CAF50"
        fill_color "F1F8F4"
        fill_rectangle [bounds.left, bounds.top], bounds.width, bounds.height
        fill_color "000000"

        pad(12) do
          text "COMPROBANTE PAGADA", size: 11, style: :bold, color: "2E7D32"
          move_down 3
          text "Este comprobante ha sido pagada exitosamente.", size: 9, color: "2E7D32"
        end
      end
    else
      # Caja con borde para estado pendiente
      bounding_box([0, current_cursor], width: bounds.width, height: 50) do
        stroke_bounds
        stroke_color "FF9800"
        fill_color "FFF8E1"
        fill_rectangle [bounds.left, bounds.top], bounds.width, bounds.height
        fill_color "000000"

        pad(12) do
          text "PENDIENTE DE PAGO", size: 11, style: :bold, color: "F57C00"
          move_down 3
          text "Este comprobante esta pendiente de pago.", size: 9, color: "F57C00"
        end
      end
    end

    move_down 65

    # Pie de página
    stroke_color "CCCCCC"
    stroke_horizontal_rule
    move_down 12
    text "Gracias por su compra. Para cualquier consulta, contactenos en alma@designalma.com",
         size: 8, align: :center, color: "888888"
  end

  def format_currency(amount)
    "$#{sprintf("%.0f", amount).reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse}"
  end
end
