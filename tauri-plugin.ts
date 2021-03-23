import { TauriConfig } from 'tauri/src/types'
import type { Plugin, ConfigEnv, ResolvedConfig } from 'vite'
import tauriConf from './src-tauri/tauri.conf.json'
import dev from 'tauri/dist/api/dev'
import build from 'tauri/dist/api/build'
import replace from '@rollup/plugin-replace'
import { isAbsolute, resolve } from 'path'

interface Options {
  config?: (c: TauriConfig, e: ConfigEnv) => TauriConfig
}

export default (options?: Options): Plugin => {
  let tauriConfig = { ...tauriConf }
  let viteConfig: ResolvedConfig
  return {
    ...replace({
      'process.env.IS_TAURI': true
    }),
    name: 'tauri-plugin',
    configureServer(server) {
      server.httpServer.on('listening', () => {
        if (!process.env.TAURI_SERVE) {
          process.env.TAURI_SERVE = 'true'
          const serverOptions = server.config.server || {};
          let port = serverOptions.port || 3000;
          let hostname = serverOptions.host || 'localhost';
          if (hostname === '0.0.0.0') {
            hostname = 'localhost';
          }
          const protocol = serverOptions.https ? 'https' : 'http';
          const base = server.config.base;
          const url = `${protocol}://${hostname}:${port}${base}`;
          tauriConfig.build.devPath = url
          dev(tauriConfig)
        }
      })
    },
    closeBundle() {
      if (!process.env.TAURI_BUILD) {
        process.env.TAURI_BUILD = 'true'
        let distDir = viteConfig.build.outDir
        if (!isAbsolute(distDir)) {
          distDir = resolve(viteConfig.root, distDir)
        }
        tauriConfig.build.distDir = distDir
        return build(tauriConfig)
      }
    },
    config(viteConfig, env) {
      process.env.IS_TAURI = 'true'
      if (options && options.config) {
        options.config(tauriConfig, env)
      }
      if (env.command === 'build') {
        viteConfig.base = '/'
      }
    },
    configResolved(resolvedConfig) {
      viteConfig = resolvedConfig
    }
  }
}
