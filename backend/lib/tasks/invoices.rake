namespace :invoices do
  desc "Sync invoice statuses with their corresponding order statuses"
  task sync_statuses: :environment do
    puts "Sincronizando estados de comprobante con órdenes..."

    updated_count = 0

    Invoice.includes(:order).each do |invoice|
      old_status = invoice.status
      invoice.sync_status_with_order

      if invoice.changed?
        invoice.save!
        puts "comprobante ##{invoice.invoice_number}: #{old_status} -> #{invoice.status}"
        updated_count += 1
      end
    end

    puts "Se actualizaron #{updated_count} comprobantes."
  end
end
