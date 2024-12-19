fn fie(s: String) {
    println!("{s}");
}
fn main() {
    let x = String::from("Ciao");
    fie(x);
    println!("{x}"); // errore di ownership
}
