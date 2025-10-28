class Invoice < ApplicationRecord
  belongs_to :order
  has_one :user, through: :order

  enum :status, { pending: 0, sent: 1, paid: 2, overdue: 3, cancelled: 4 }

  validates :invoice_number, presence: true, uniqueness: true
  validates :date, presence: true
  validates :subtotal, :total, presence: true, numericality: { greater_than: 0 }
  validates :tax, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_invoice_number, if: :new_record?
  before_validation :set_date, if: :new_record?
  before_validation :calculate_totals
  before_validation :sync_status_with_order

  scope :by_status, ->(status) { where(status: status) }
  scope :by_date_range, ->(start_date, end_date) { where(date: start_date..end_date) }
  scope :recent, -> { order(date: :desc) }

  def self.generate_for_order(order)
    return nil unless order.paid?

    invoice = new(order: order)
    invoice.subtotal = order.total
    invoice.tax = calculate_tax(order.total)
    invoice.total = invoice.subtotal + invoice.tax
    invoice.save!
    invoice
  end

  def formatted_invoice_number
    "INV-#{invoice_number}"
  end

  def overdue?
    due_date.present? && due_date < Date.current && !paid?
  end

  private

  def set_invoice_number
    last_invoice = Invoice.order(:created_at).last
    if last_invoice
      last_number = last_invoice.invoice_number.split("-").last.to_i
      self.invoice_number = "#{Date.current.strftime("%Y%m")}-#{(last_number + 1).to_s.rjust(4, "0")}"
    else
      self.invoice_number = "#{Date.current.strftime("%Y%m")}-0001"
    end
  end

  def set_date
    self.date = Date.current
    self.due_date = Date.current + 30.days if due_date.blank?
  end

  def calculate_totals
    return unless subtotal.present?

    self.tax = self.class.calculate_tax(subtotal) if tax.blank?
    self.total = subtotal + (tax || 0)
  end

  def self.calculate_tax(amount)
    # IVA del 19% en Colombia - puedes ajustar según tu país
    (amount * 0.19).round(2)
  end

  def sync_status_with_order
    return unless order.present?

    if order.paid? && pending?
      self.status = :paid
    elsif order.cancelled? && !cancelled?
      self.status = :cancelled
    end
  end
end
