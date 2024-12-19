fn main() {
    let mut x = String::from("Ciao");
    let y = &mut x; // borrow di x a y (mutabile)
    y.push_str(", mondo");
    println!("{y}"); // output: Ciao, mondo
    println!("{x}"); // output: Ciao, mondo
}
