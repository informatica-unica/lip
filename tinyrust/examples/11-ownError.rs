fn main() {
    let x = String::from("Ciao");
    let y = x;
    println!("{x}"); // errore di ownership
}
