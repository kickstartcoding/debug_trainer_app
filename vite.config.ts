import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tauri from './tauri-plugin'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue(), tauri()]
})
