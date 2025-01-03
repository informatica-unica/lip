fn main() {
  let x = 4;
  {
    fn interna (y: &i32) {
      println!("{y}");
    }
    interna(&x);
  }
  interna(&x); // errore: not found in this scope
}
