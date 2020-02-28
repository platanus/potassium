import Vue from 'vue/dist/vue.esm';
import AdminComponent from '../components/admin-component';

Vue.component('admin_component', AdminComponent);

document.addEventListener('DOMContentLoaded', () => {
  if (document.getElementById('wrapper') !== null) {
    return new Vue({
      el: '#wrapper',
    });
  }

  return null;
});
