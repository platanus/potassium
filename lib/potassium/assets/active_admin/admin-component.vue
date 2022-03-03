<script setup lang="ts">
interface Props {
  test?: string
  testNumber?: number
  testObject?: {[key: string]: string},
  testList?: number[],
}

const props = withDefaults(
  defineProps<Props>(),
  {
    test: undefined,
    testNumber: 0,
    testObject: undefined,
    testList: undefined,
  },
);

const message = 'Hello World';
</script>

<template>
  <div>
    I am a Vue Component {{ props.test }} {{ message }}
    <slot />
  </div>
</template>
