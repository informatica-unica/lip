fn main () {
  let mut y = 3;
  loop {
    if y==0 { break; } 
    else { println!("{y}"); y = y-1; }
  }
  println!("{y}");
}
