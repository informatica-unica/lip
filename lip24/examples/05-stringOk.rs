fn main () {
  let mut x = String::from("Ciao");
  x.push_str(", mondo"); // ok: x mutabile
  println!("{x}");       // output: Ciao, mondo
}
