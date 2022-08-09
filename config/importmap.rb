# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin 'sweetalert2', to: './node_modules/sweetalert2', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin "sweetalert2", to: "https://ga.jspm.io/npm:sweetalert2@11.4.26/dist/sweetalert2.all.js"
