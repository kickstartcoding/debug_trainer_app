import { Elm } from "../elm/Main"

const app = Elm.Main.init({ flags: null })


app.ports.interopToElm.send({
  tag: "gotFileChoice",
  data: "chosen file"
})

app.ports.interopFromElm.subscribe((fromElm) => {
  switch (fromElm.tag) {
    case "chooseFile":
      break
  }
})