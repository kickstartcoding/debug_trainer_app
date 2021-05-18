import { Elm } from '../elm/Main'
import { open } from '@tauri-apps/api/dialog'
import { readTextFile, writeFile } from '@tauri-apps/api/fs'

console.log("START")

const app = Elm.Main.init({
  flags: {
    randomNumbers: getRandomInts(1_000_000, 20)
  }
})

console.log('app:', app)



app.ports.interopFromElm.subscribe((fromElm) => {
  switch (fromElm.tag) {
    case "chooseFile":
      console.log('fromElm:', fromElm)

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
  }
})


function getRandomInts(max: number, count: number): number[] {
  return [...Array(count)].map(() => getRandomInt(max))
}

function getRandomInt(max: number): number {
  return Math.floor(Math.random() * Math.floor(max))
}