fn bar(x: i32) { // dichiarazione di procedura
    let mut y = 4;
    y = y + x;
    println!("{y}"); // nessun valore di ritorno
}
fn main() {
    let x = 3;
    bar(x); // chiamata di procedura
}
