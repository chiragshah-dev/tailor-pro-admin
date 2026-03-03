function initLoginUI() {

    const isLoginPage = document.getElementById("login-page")
    if (!isLoginPage) return

    const wrapper = document.getElementById('revealWrapper');

    const scissors = document.getElementById('scissors');

    const viewportCenter = document.getElementById('viewportCenter');

    const toggleBtn = document.getElementById('togglePassword');
    const errorMsg = document.getElementById('errorPresence');

    if (!wrapper || !viewportCenter) return;
    // ANIMATION
    if (errorMsg) {
        wrapper.style.display = 'none';
        viewportCenter.classList.add('show-now');
    } else {
        wrapper.style.display = 'block';

        

        setTimeout(() => {
            scissors && scissors.classList.add('scissors-moving');
        }, 100);

        setTimeout(() => {
            wrapper.classList.add('active');
        }, 1700);
    }

    // PASSWORD TOGGLE
    if (toggleBtn) {
        toggleBtn.onclick = function () {
            const input = document.getElementById('admin_password');
            const icon = document.getElementById('eyeIcon');
            if (!input || !icon) return;

            input.type = input.type === 'password' ? 'text' : 'password';
            icon.classList.toggle('fa-eye');
            icon.classList.toggle('fa-eye-slash');
        };
    }
}

document.addEventListener('turbo:load', initLoginUI);
document.addEventListener('turbo:render', initLoginUI);
