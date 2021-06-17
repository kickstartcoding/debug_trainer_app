#![cfg_attr(
  all(not(debug_assertions), target_os = "windows"),
  windows_subsystem = "windows"
)]

// use tauri::{CustomMenuItem, Menu, MenuItem};

fn main() {
  // let quit = CustomMenuItem::new("quit".to_string(), "Quit");
  // let menu = vec![
  //   Menu::new("Debug Trainer", vec![
  //     MenuItem::Custom(quit),
  //   ])
  // ];

  tauri::Builder::default()
    // .menu(menu)
    // .on_menu_event(|event| {
    //   match event.menu_item_id().as_str() {
    //     "quit" => {
    //       std::process::exit(0);
    //     }
    //     _ => {}
    //   }
    // })
    .run(tauri::generate_context!())
    .expect("error while running tauri application");
}
