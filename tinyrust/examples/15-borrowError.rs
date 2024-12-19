fn main() {
    let mut x = String::from("Ciao");
    let y = &x;
    x.push_str(", mondo"); // errore: y non mutabile
    println!("{y}");
}
