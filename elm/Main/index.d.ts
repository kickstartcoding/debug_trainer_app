export type JsonObject = { [Key in string]?: JsonValue }
export interface JsonArray extends Array<JsonValue> {}

/**
Matches any valid JSON value.
Source: https://github.com/sindresorhus/type-fest/blob/master/source/basic.d.ts
*/
export type JsonValue =
  | string
  | number
  | boolean
  | null
  | JsonObject
  | JsonArray

export interface ElmApp {
  ports: {
    interopFromElm: PortFromElm<FromElm>
    interopToElm: PortToElm<ToElm>
    [key: string]: UnknownPort
  }
}

export type FromElm =
  | { data: { content: string; path: string }; tag: "writeFile" }
  | { data: null; tag: "chooseFile" }

export type ToElm = {
  data: { content: string; path: string }
  tag: "gotFileChoice"
}

export type Flags = null

export namespace Main {
  function init(options: { node?: HTMLElement | null; flags: Flags }): ElmApp
}

export as namespace Elm

export { Elm }

export type UnknownPort = PortFromElm<unknown> | PortToElm<unknown> | undefined

export type PortFromElm<Data> = {
  subscribe(callback: (fromElm: Data) => void): void
  unsubscribe(callback: (fromElm: Data) => void): void
}

export type PortToElm<Data> = { send(data: Data): void }
