fn presta(y: &String) {
    println!("il parametro prestato: {y}");
}
fn main() {
    let x = String::from("Ciao");
    presta(&x); // reference (immutabile) a x
    println!("il parametro x: {x}");
}
