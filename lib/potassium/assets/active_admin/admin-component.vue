<template>
  <div>
    I am a Vue Component {{ test }} {{ message }}
    <slot />
  </div>
</template>

<script>
export default {
  props: {
    test: {
      type: String,
      default: '',
    },
    testNumber: {
      type: Number,
      default: 0,
    },
    testObject: {
      type: Object,
      default: null,
    },
    testList: {
      type: Array,
      default: null,
    },
  },

  data() {
    return {
      message: 'Hello World',
    };
  },
};
</script>
