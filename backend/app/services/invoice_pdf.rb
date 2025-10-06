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
    # Información del cliente
    bounding_box([0, cursor], width: 250, height: 80) do
      text "FACTURAR A:", size: 11, style: :bold, color: "666666"
      move_down 5
      text "#{@user.name} #{@user.last_name}", size: 12, style: :bold
      text "#{@user.email}", size: 10
      text "#{@user.phone}", size: 10 if @user.phone.present?
      if @user.address.present?
        text "#{@user.address}", size: 10
      end
      if @user.city.present?
        text "#{@user.city}", size: 10
      end
    end

    move_down 40
  end

  def items_table
    text "PRODUCTOS", size: 14, style: :bold
    move_down 10

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
      row(0).background_color = "F0F0F0"
      columns(2..4).align = :right
      self.cell_style = { padding: [8, 10], border_width: 0.5, border_color: "DDDDDD" }
      self.header = true
    end

    move_down 20
  end

  def totals
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
      self.cell_style = { padding: [5, 10], border_width: 0.5, border_color: "DDDDDD" }
    end

    move_down 30
  end

  def footer
    # Estado de pago
    if @invoice.paid?
      bounding_box([0, cursor], width: bounds.width) do
        fill_color "E8F5E8"
        fill_rectangle [0, 40], bounds.width, 40
        fill_color "000000"

        bounding_box([10, cursor - 10], width: bounds.width - 20) do
          text "FACTURA PAGADA", size: 12, style: :bold, color: "2E7D32"
          text "Esta factura ha sido pagada exitosamente.", size: 10, color: "2E7D32"
        end
      end
    else
      bounding_box([0, cursor], width: bounds.width) do
        fill_color "FFF3E0"
        fill_rectangle [0, 40], bounds.width, 40
        fill_color "000000"

        bounding_box([10, cursor - 10], width: bounds.width - 20) do
          text "PENDIENTE DE PAGO", size: 12, style: :bold, color: "F57C00"
          text "Esta factura esta pendiente de pago.", size: 10, color: "F57C00"
        end
      end
    end

    move_down 60

    # Pie de página
    bounding_box([0, 50], width: bounds.width) do
      stroke_horizontal_rule
      move_down 10
      text "Gracias por su compra. Para cualquier consulta, contactenos en contacto@empresa.com",
           size: 9, align: :center, color: "666666"
    end
  end

  def format_currency(amount)
    "$#{sprintf("%.0f", amount).reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse}"
  end
end
