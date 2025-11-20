class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invoice, only: [:show, :download]

  def index
    @invoices = Invoice.joins(:order)
      .where(orders: { user_id: current_user.id })
      .includes(:order)
      .order(date: :desc)
    @pending_invoices = @invoices.select(&:pending?)
    @paid_invoices = @invoices.select(&:paid?)
  end

  def show
    @order = @invoice.order
    @order_items = @order.order_items.includes(:product)
  end

  def download
    respond_to do |format|
      format.pdf do
        begin
          pdf = InvoicePdf.new(@invoice)
          send_data pdf.render,
                    filename: "comprobante_#{@invoice.formatted_invoice_number}.pdf",
                    type: "application/pdf",
                    disposition: "attachment"
        rescue => e
          Rails.logger.error "Error generando PDF: #{e.message}"
          redirect_to invoice_path(@invoice), alert: "Error al generar el PDF"
        end
      end
    end
  end

  private

  def set_invoice
    @invoice = Invoice.joins(:order)
      .where(orders: { user_id: current_user.id })
      .find(params[:id])
    redirect_to invoices_path, alert: t("invoice.not_found") unless @invoice
  rescue ActiveRecord::RecordNotFound
    redirect_to invoices_path, alert: t("invoice.not_found")
  end
end
