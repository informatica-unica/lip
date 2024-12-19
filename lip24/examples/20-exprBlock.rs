fn main() {
  let x = {
    let y = 5;
    y+2        // valore restituito dal blocco
  };
  println!("{x}"); // output: 7
}
