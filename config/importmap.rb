pin "application"

pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js"
pin "@hotwired/turbo", to: "@hotwired--turbo.js"

pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "jquery", to: "https://code.jquery.com/jquery-3.6.0.min.js"
pin "jquery-ui", to: "https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"
pin_all_from "app/javascript/core", under: "core"
pin_all_from "app/javascript/plugins", under: "plugins"
pin_all_from "app/javascript/custom", under: "custom"
pin_all_from "app/javascript/controllers", under: "controllers"
