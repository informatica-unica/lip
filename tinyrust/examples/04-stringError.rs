fn main() {
    let x = String::from("Ciao");
    x.push_str(", mondo"); // errore: x non mutabile
    println!("{x}");
}
