use flutter_rust_bridge::frb;
use ignore::WalkBuilder;
use std::path::Path;

const IGNORE_FILE: &str = ".projectignore";

#[frb]
pub fn list_non_ignored_files(dir: String) -> Vec<String> {
    let dir = Path::new(&dir);
    let mut files = Vec::new();
    let walker = WalkBuilder::new(dir)
        .git_ignore(true)
        .add_custom_ignore_filename(IGNORE_FILE)
        .build();

    for entry in walker.filter_map(Result::ok) {
        if entry.file_type().map_or(false, |ft| ft.is_file()) {
            if let Some(path) = entry.path().to_str() {
                files.push(path.to_string());
            }
        }
    }

    files
}
