fn main() {
    let x = String::from("Ciao");
    let y = &mut x; // errore: x non mutabile
    y.push_str(", mondo");
    println!("{y}");
    println!("{x}");
}
