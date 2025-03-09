# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Bootstrap
pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js", preload: true

pin "popper", to: 'popper.js', preload: true

# DataTables, Buttons Plugin, and jQuery
pin "datatables.net"                   , to: "https://cdn.datatables.net/2.1.8/js/dataTables.mjs"
pin "datatables.net-bs5"               , to: "https://cdn.datatables.net/2.1.8/js/dataTables.bootstrap5.mjs"
pin "datatables.net-fixedcolumns"      , to: "https://cdn.datatables.net/fixedcolumns/5.0.3/js/dataTables.fixedColumns.mjs"
pin "datatables.net-fixedcolumns-bs5"  , to: "https://cdn.datatables.net/fixedcolumns/5.0.3/js/fixedColumns.bootstrap5.mjs"
pin "jquery"                           , to: "https://ga.jspm.io/npm:jquery@3.6.1/dist/jquery.js"
pin "trix"                             , to: "https://ga.jspm.io/npm:trix@2.0.0-alpha.1/dist/trix.js"
pin "@rails/actiontext"                , to: "actiontext.js"
