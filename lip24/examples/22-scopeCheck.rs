fn main() {
  let mut y = 4;
  fn scopecheck () {
      y = 6; // errore 
  }
  y = 3+y;
}
