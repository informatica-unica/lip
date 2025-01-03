fn main() {
    let mut x = String::from("Ciao");
    let y = &x;
    x.push_str(", mondo"); // errore: cannot borrow x as mutable because it is also borrowed as immutable
    println!("{y}");
}

// Note: push_str borrows x as mutable
// signature of push_str:
// pub fn push_str(&mut self, string: &str)
