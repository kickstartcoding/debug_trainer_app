import { Elm } from "../elm/Main"
import { open } from "@tauri-apps/api/dialog"

console.log("START")

const app = Elm.Main.init({ flags: null })

console.log('app:', app)


app.ports.interopToElm.send({
  tag: "gotFileChoice",
  data: "chosen file"
})

app.ports.interopFromElm.subscribe((fromElm) => {
  switch (fromElm.tag) {
    case "chooseFile":
      console.log('fromElm:', fromElm)
      // Unhandled Promise Rejection: TypeError: undefined is not an object (evaluating 'window.rpc.notify')

      open().then((selection) => {
        window.selection = selection
        console.log('selection:', selection)
      })
      break
  }
})