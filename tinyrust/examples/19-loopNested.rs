fn main () {
  let mut i = 0;
  loop {
    let mut j=0;
    loop {
      if j==2 { break; } 
      else { println!("{i},{j}"); j = j+1; }
    };
    if i==2 { break; }
    else {i = i+1; }
  }
}
