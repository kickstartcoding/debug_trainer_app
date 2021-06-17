import { Elm } from '../elm/Main'
import { open } from '@tauri-apps/api/dialog'
import { readTextFile, writeFile } from '@tauri-apps/api/fs'
import { exit } from '@tauri-apps/api/process'
import { register } from '@tauri-apps/api/globalShortcut'
import logo from './assets/logo.png'

register("CmdOrControl+Q", () => {
  exit()
})

const app = Elm.Main.init({
  flags: {
    randomNumbers: getRandomInts(1_000_000, 20),
    logo: logo,
    mode: process.env.NODE_ENV || null
  }
})

app.ports.interopFromElm.subscribe((fromElm) => {
  switch (fromElm.tag) {
    case "chooseFile":
      open().then((filepath) => {
        if (typeof filepath === 'string') {
          readTextFile(filepath).then((content) => {
            app.ports.interopToElm.send({
              tag: "gotFileChoice",
              data: { path: filepath, content }
            })
          })
        } else {
          alert("Multiple files chosen, but should be only one file!")
        }
      })
      break
    case "writeFile":
      writeFile({
        path: fromElm.data.path,
        contents: fromElm.data.content
      }).then(() => {
        app.ports.interopToElm.send({
          tag: "fileChangeWasSaved",
          data: null
        })
      })
      break
    case "writeFileAndExit":
      writeFile({
        path: fromElm.data.path,
        contents: fromElm.data.content
      }).then(() => exit())
  }
})

function getRandomInts(max: number, count: number): number[] {
  return [...Array(count)].map(() => getRandomInt(max))
}

function getRandomInt(max: number): number {
  return Math.floor(Math.random() * Math.floor(max))
}