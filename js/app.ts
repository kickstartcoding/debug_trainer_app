import { Elm } from '../elm/Main'
import { open } from '@tauri-apps/api/dialog'
import { readTextFile } from '@tauri-apps/api/fs'

console.log("START")

const app = Elm.Main.init({ flags: null })

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
  }
})