import "jquery"
import "jquery-ui"
import "@hotwired/turbo-rails"
import "@hotwired/stimulus"
import "controllers"



// Core
import "core/bootstrap.bundle.min"
import "core/popper.min"

// 
import "plugins/material-dashboard"
import "plugins/perfect-scrollbar.min"

// Custom
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



import "@hotwired/turbo-rails"
import "@hotwired/stimulus"
import "controllers"



// Core
import "core/bootstrap.bundle.min"
import "core/popper.min"

// 
import "plugins/material-dashboard"
import "plugins/perfect-scrollbar.min"

// Custom
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




document.addEventListener("turbo:load", () => {
  const $table = $("#sortable_table");

  if ($table.length === 0) return;

  const reorderUrl = $table.data("reorder-url");

  if ($table.data("ui-sortable")) {
    $table.sortable("destroy");
  }

  $table.sortable({
    items: "tr",
    cursor: "move",
    opacity: 0.7,
    axis: "y",

    update: function () {
      const items = [];

      $("#sortable_table tr").each(function () {
        const id = $(this).attr("id");
        if (id) {
          items.push(id.replace("sortable_item", ""));
        }
      });

      $.ajax({
        type: "POST",
        url: reorderUrl,
        dataType: "json",
        data: {
          data_items: items,
          authenticity_token: $('meta[name="csrf-token"]').attr("content"),
        },
      });
    },
  });
});