class Admin::InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_invoice, only: [:show, :destroy, :download, :mark_as_sent, :mark_as_paid, :regenerate]

  def index
    @invoices = Invoice.includes(:order).all
    @invoices = @invoices.where(status: params[:status]) if params[:status].present?
    @invoices = @invoices.order(created_at: :desc)
  end

  def show
  end

  def download
    begin
      pdf_service = InvoicePdf.new(@invoice)
      pdf_content = pdf_service.generate
      
      send_data pdf_content,
                filename: "factura-#{@invoice.invoice_number}.pdf",
                type: 'application/pdf',
                disposition: 'attachment'
    rescue => e
      Rails.logger.error "Error generating PDF: #{e.message}"
      redirect_to admin_invoice_path(@invoice), alert: "Error al generar el PDF: #{e.message}"
    end
  end

  def mark_as_sent
    @invoice.update!(status: :sent)
    redirect_to admin_invoice_path(@invoice), notice: 'Factura marcada como enviada'
  end

  def mark_as_paid
    @invoice.update!(status: :paid)
    @invoice.order.update!(status: :paid) if @invoice.order.status != 'paid'
    redirect_to admin_invoice_path(@invoice), notice: 'Factura marcada como pagada'
  end

  def regenerate
    @invoice.update!(
      subtotal: @invoice.order.subtotal,
      tax: @invoice.order.tax_amount,
      total: @invoice.order.total_amount
    )
    redirect_to admin_invoice_path(@invoice), notice: 'Factura regenerada exitosamente'
  end

  def destroy
    @invoice.destroy!
    redirect_to admin_invoices_path, notice: 'Factura eliminada exitosamente'
  end

  def bulk_delete
    ids = params[:invoice_ids]
    if ids.present?
      Invoice.where(id: ids).destroy_all
      redirect_to admin_invoices_path, notice: "#{ids.length} facturas eliminadas"
    else
      redirect_to admin_invoices_path, alert: "No se seleccionaron facturas"
    end
  end

  private

  def set_invoice
    @invoice = Invoice.includes(order: { order_items: :product }).find(params[:id])
  end

  def ensure_admin
    redirect_to root_path unless current_user&.admin?
  end
end
