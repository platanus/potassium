import Vue from 'vue';
import AdminComponent from './components/admin-component';

Vue.component('admin_component', AdminComponent);

function onLoad() {
  if (document.getElementById('wrapper') !== null) {
    new Vue({
      el: '#wrapper',
      async mounted() {
        // We need to re-trigger DOMContentLoaded for ArcticAdmin after Vue replaces DOM elements
        window.document.dispatchEvent(new Event("DOMContentLoaded", {
          bubbles: true,
          cancelable: true
        }));
      }
    });
  }
}

document.addEventListener('DOMContentLoaded', onLoad, { once: true });

