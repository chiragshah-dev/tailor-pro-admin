// confirmation modal override
Turbo.setConfirmMethod((message) => {
  return new Promise((resolve) => {
    const modalEl = document.getElementById("turboConfirmModal")
    const messageEl = document.getElementById("turboConfirmMessage")
    const okBtn = document.getElementById("turboConfirmOk")

    messageEl.textContent = message

    document.body.classList.add("modal-confirm-open")

    const modal = new bootstrap.Modal(modalEl)
    modal.show()

    okBtn.onclick = () => {
      modal.hide()
      resolve(true)
    }

    modalEl.addEventListener(
      "hidden.bs.modal",
      () => {
        document.body.classList.remove("modal-confirm-open")
        resolve(false)
      },
      { once: true }
    )
  })
})
