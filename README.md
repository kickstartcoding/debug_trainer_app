# Debug Trainer

## What is it?

Debug Trainer is an app that can randomly add bugs to files so that people learning to program can practice debugging those bugs in a context where they can get hints and help and where the bugs can be automatically removed if they can't figure them out.

## How do I use it?

Download the latest release on [the latest release page](https://github.com/kickstartcoding/debug_trainer_app/releases/latest) and start it up! Grab the `.dmg` file if you’re a Mac user, the `.deb` file if you’re on Linux, and the `.msi` file if you’re on Windows.

## Stack

Debug Trainer runs on the [Tauri](https://tauri.studio) platform using a front-end composed mainly of [Elm](https://elm-lang.org/) code with a bit of [Typescript](https://www.typescriptlang.org/) to tie it together.

## Development

Since auto-reloading the complete app including Tauri can be unreliable, for most changes you can just run the Elm front-end via the `npm run dev:web:elm` command. If you need to test out the file read/write capabilities as well, you'll need to run it with `npm run dev` which will run [elm-live](https://www.elm-live.com/), [Parcel](https://v2.parceljs.org/), and the [Tauri](https://tauri.studio) backend all at once.

## Building

`npm run build` will build the final app, though this is usually done via [the Tauri cross-platform compilation GitHub action](https://tauri.studio/en/docs/usage/ci-cd/cross-platform/) so that we can build for Mac, Linux, and Windows all at once.