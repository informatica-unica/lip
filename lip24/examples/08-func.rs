fn foo(x: i32) -> i32 { // dichiarazione di funzione
    let mut y = 4; // ambiente locale
    y = y + x;
    y + x // valore di ritorno
}
fn main() {
    let x = 3;
    let y = foo(x); // chiamata di funzione
    println!("{y}"); // output: 10
}
