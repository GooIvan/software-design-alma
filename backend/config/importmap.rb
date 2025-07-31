# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "custom/init_sidebar", to: "custom/init_sidebar.js"
pin "custom/init_dark_mode", to: "custom/init_dark_mode.js"
pin "custom/init_carousel_images", to: "custom/init_carousel_images.js"
pin "custom/init_change_lenguage", to: "custom/init_change_lenguage.js"
pin "custom/init_chart_js_last_month", to: "custom/init_chart_js_last_month.js"
pin "custom/init_chart_js_pie", to: "custom/init_chart_js_pie.js"
pin "custom/admin/init_order_items", to: "custom/admin/init_order_items.js"