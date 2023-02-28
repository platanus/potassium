import { fileURLToPath, URL } from 'node:url';
import { defineConfig } from 'vitest/config'
import RubyPlugin from 'vite-plugin-ruby';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
  plugins: [
    RubyPlugin(),
    vue()
  ],
  resolve: {
    alias: {
      vue: 'vue/dist/vue.esm-bundler.js',
      '@': fileURLToPath(new URL('./app/frontend', import.meta.url)),
    },
  },
  test: {
    globals: true,
    environment: 'jsdom',
    coverage: {
      provider: 'c8',
      all: true,
      include: ['app/frontend/**/*.{js,ts,vue}'],
      exclude: [
        /* default excludes */
        'coverage/**',
        'dist/**',
        'packages/*/test{,s}/**',
        '**/*.d.ts',
        'cypress/**',
        'test{,s}/**',
        'test{,-*}.{js,cjs,mjs,ts,tsx,jsx}',
        '**/*{.,-}test.{js,cjs,mjs,ts,tsx,jsx}',
        '**/*{.,-}spec.{js,cjs,mjs,ts,tsx,jsx}',
        '**/__tests__/**',
        '**/{karma,rollup,webpack,vite,vitest,jest,ava,babel,nyc,cypress,tsup,build}.config.*',
        '**/.{eslint,mocha,prettier}rc.{js,cjs,yml}',
        /* custom excludes */
        'app/frontend/**/*.spec.{js,ts,vue}',
        'app/frontend/**/*.mock.{js,ts,vue}',
        'app/frontend/active_admin/jquery.js',
        'app/frontend/entrypoints',
      ]
    }
  },
})
