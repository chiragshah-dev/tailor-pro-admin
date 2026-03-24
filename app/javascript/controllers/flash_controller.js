import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Animate in shortly after it appears in the DOM
    setTimeout(() => {
      this.element.classList.add("show")
    }, 200)

    // Automatically close after 4 seconds
    this.timeout = setTimeout(() => {
      this.close()
    }, 4000)
  }

  disconnect() {
    // Clean up the timeout if Turbo navigates away before the 4 seconds are up
    clearTimeout(this.timeout)
  }

  close() {
    this.element.classList.remove("show")
    
    //  Completely remove the element from the DOM after the CSS transition finishes
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}