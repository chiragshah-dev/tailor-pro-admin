import * as Turbo from "https://cdn.jsdelivr.net/npm/@hotwired/turbo/+esm";
Turbo.start()


// Core
import "core/bootstrap.bundle.min"
import "core/popper.min"

import "plugins/material-dashboard"
// import "plugins/bootstrap-notify"
// import "plugins/Chart.extension"
// import "plugins/chartjs.min"
// import "plugins/countup.min"
import "plugins/perfect-scrollbar.min"
// import "plugins/world"

import "custom/central"
import "custom/login"

document.addEventListener("turbo:load", () => {
  const confirmBtn = document.getElementById("turboConfirmOk");
  const confirmMsg = document.getElementById("turboConfirmMessage");

  if (!confirmBtn) return;

  document.addEventListener("click", (event) => {
    const trigger = event.target.closest("[data-turbo-confirm]");
    if (!trigger) return;

    const action = trigger.dataset.confirmAction;

    if (action === "logout") {
      confirmBtn.textContent = "LOGOUT";

      if (confirmMsg) {
        confirmMsg.innerHTML = `
          Are you sure you want to logout?
          <br />
          <span class="tp-confirm-subtext">
            You will be signed out of your account.
          </span>
        `;
      }
    } else {
      // ✅ DEFAULT: DELETE (no confirm_action needed)
      confirmBtn.textContent = "DELETE";

      if (confirmMsg) {
        confirmMsg.innerHTML = `
          Are you sure you want to delete this item?
          <br />
          <span class="tp-confirm-subtext">
            This action cannot be undone.
          </span>
        `;
      }
    }
  });
});
