// From: https://github.com/rails/rails/blob/main/actionview/app/javascript/rails-ujs/utils/csrf.js
function csrfToken() {
  const meta = document.querySelector('meta[name=csrf-token]');
  const token = meta && meta.getAttribute('content');

  return token ?? false;
}

export { csrfToken };
