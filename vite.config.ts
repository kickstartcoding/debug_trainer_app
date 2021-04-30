import { defineConfig } from 'vite'
import tauri from './tauri-plugin'
import elmPlugin from 'vite-plugin-elm'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [elmPlugin(), tauri()]
})
