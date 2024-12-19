fn main() {
    let mut x = 3; // variabile mutabile di tipo intero
    let y = x + 1;
    x = x + y; // ok: x mutabile
    println!("{x}"); // output: 7
}
