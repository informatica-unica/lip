fn main() {
    let x = 3; // dichiarazione iniziale di x
    {
        let y = x + 1; // dichiarazione di y
    }
    println!("{y}"); // errore, y non in scope
}
