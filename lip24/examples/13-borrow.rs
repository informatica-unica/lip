fn main() {
    let x = String::from("Ciao");
    let y = &x; // borrow di x a y
    println!("{y}"); // output: Ciao
    println!("{x}"); // output: Ciao
}
