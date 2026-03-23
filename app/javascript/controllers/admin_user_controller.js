import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "email",
    "password",
    "passwordConfirmation",
    "passwordIcon",
    "passwordConfirmationIcon"
  ]

  connect() {
    this.isEdit = this.element.dataset.isEdit === "true"
  }

  togglePassword(e) {
    e.preventDefault()
    this._toggle(this.passwordTarget, this.passwordIconTarget)
  }

  togglePasswordConfirmation(e) {
    e.preventDefault()
    this._toggle(this.passwordConfirmationTarget, this.passwordConfirmationIconTarget)
  }

  _toggle(input, button) {
    const icon = button.querySelector("i")
    
    if (input.type === "password") {
      input.type = "text"
      icon.setAttribute("class", "fa fa-eye-slash")
    } else {
      input.type = "password"
      icon.setAttribute("class", "fa fa-eye")
    }
  }

  submit(e) {
    let valid = true

    const email = this.emailTarget.value.trim()
    if (!email) {
      this._showError(this.emailTarget, "Email is required")
      valid = false
    } else if (!this._isValidEmail(email)) {
      this._showError(this.emailTarget, "Invalid email")
      valid = false
    } else {
      this._clearError(this.emailTarget)
    }

    const password = this.passwordTarget.value
    if (!this.isEdit && !password) {
      this._showError(this.passwordTarget, "Password is required")
      valid = false
    } else if (password && password.length < 6) {
      this._showError(this.passwordTarget, "Minimum 6 characters required")
      valid = false
    } else {
      this._clearError(this.passwordTarget)
    }

    const passwordConfirm = this.passwordConfirmationTarget.value
    if (password && passwordConfirm !== password) {
      this._showError(this.passwordConfirmationTarget, "Passwords do not match")
      valid = false
    } else {
      this._clearError(this.passwordConfirmationTarget)
    }

    if (!valid) e.preventDefault()
  }

  clearError(e) {
    this._clearError(e.target)
  }

  _isValidEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
  }

  _showError(input, message) {
    input.classList.add("is-invalid")
    const errorDiv = input.closest(".col-md-6")?.querySelector(".text-danger")
    if (errorDiv) {
      errorDiv.textContent = message
    }
  }

  _clearError(input) {
    input.classList.remove("is-invalid")
    const errorDiv = input.closest(".col-md-6")?.querySelector(".text-danger")
    if (errorDiv) {
      errorDiv.textContent = ""
    }
  }
}