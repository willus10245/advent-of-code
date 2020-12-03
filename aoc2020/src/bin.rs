use std::io;
use std::io::{Read, Write};
use std::time::{Duration, Instant};

fn run_one(day: &dyn Fn() -> String) -> (String, Duration) {
    let start = Instant::now();
    let result = day();

    (result, start.elapsed())
}

fn main() {
    let result = run_one(&aoc2020::day03::run);

    let stdout = io::stdout();
    let mut handle = stdout.lock();

    write!(handle, "{}", result.0).unwrap();
    writeln!(handle, "Took {:?}\n", result.1).unwrap();

    // ------------------------------------------------------------
    // Do not modify below this line
    // ------------------------------------------------------------
    println!("Hit enter to continue");

    let mut input = [0; 1];
    let _ = io::stdin().read_exact(&mut input);
}
