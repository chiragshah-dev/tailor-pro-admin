# # Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
# pin_all_from "app/javascript/controllers", under: "controllers"

# # ✅ REQUIRED FOR DROPDOWNS
# pin "@popperjs/core", to: "popper.js"
# pin "bootstrap", to: "bootstrap.min.js"
# pin "material-dashboard", to: "material-dashboard.min.js"

# pin "jquery-ui", to: "https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"
# pin_all_from "app/javascript/core", under: "core"
# pin_all_from "app/javascript/others", under: "others"

pin_all_from "app/javascript/core", under: "core"
pin_all_from "app/javascript/plugins", under: "plugins"
pin_all_from "app/javascript/controllers", under: "controllers"
