import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.updateParentStates()
  }

  // ===== ACTIONS =====

  toggleModule(event) {
    const moduleId = event.target.dataset.module
    this.element
      .querySelectorAll(`.module-${moduleId}`)
      .forEach(cb => (cb.checked = event.target.checked))

    this.updateParentStates()
  }

  toggleGroup(event) {
    const group = event.target.dataset.group
    this.element
      .querySelectorAll(`.group-${group}`)
      .forEach(cb => (cb.checked = event.target.checked))

    this.updateParentStates()
  }

  toggleGlobal(event) {
    const type = event.target.dataset.global
    this.element
      .querySelectorAll(`.global-${type}`)
      .forEach(cb => (cb.checked = event.target.checked))

    this.updateParentStates()
  }

  toggleSingle() {
    this.updateParentStates()
  }

  // ===== CORE LOGIC =====

  updateParentStates() {
    // MODULE
    this.element.querySelectorAll(".select-module").forEach(moduleBox => {
      const moduleId = moduleBox.dataset.module
      const all = this.element.querySelectorAll(`.module-${moduleId}`)
      moduleBox.checked = all.length > 0 && [...all].every(cb => cb.checked)
    })

    // GROUP
    this.element.querySelectorAll(".select-group").forEach(groupBox => {
      const group = groupBox.dataset.group
      const all = this.element.querySelectorAll(`.group-${group}`)
      groupBox.checked = all.length > 0 && [...all].every(cb => cb.checked)
    })

    // GLOBAL
    this.element.querySelectorAll(".select-global").forEach(globalBox => {
      const type = globalBox.dataset.global
      const all = this.element.querySelectorAll(`.global-${type}`)
      globalBox.checked = all.length > 0 && [...all].every(cb => cb.checked)
    })
  }
}