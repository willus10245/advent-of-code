use std::io;
use std::io::{Read, Write};
use std::time::{Duration, Instant};

type DayFn = fn() -> String;

#[allow(dead_code)]
fn run_one(day: &dyn Fn() -> String) -> (String, Duration) {
    let start = Instant::now();
    let result = day();

    (result, start.elapsed())
}

#[allow(dead_code)]
fn run_all(days: std::slice::Iter<'_, DayFn>) -> (Vec<String>, Duration) {
    let mut results: Vec<String> = Vec::new();

    let start = Instant::now();
    for f in days.clone() {
        results.push(f());
    }
    let elapsed = start.elapsed();

    results.push(format!("\nTotal time (single-threaded): {:?}\n", elapsed));
    (results, elapsed)
}

fn main() {
    let days = [
        aoc2020::day01::run,
        aoc2020::day02::run,
        aoc2020::day03::run,
        aoc2020::day04::run,
        aoc2020::day05::run,
    ];

    let result = run_all(days.iter());

    let stdout = io::stdout();
    let mut handle = stdout.lock();

    for result in result.0 {
        write!(handle, "{}", result).unwrap();
    }
    writeln!(handle, "Took {:?}\n", result.1).unwrap();

    // ------------------------------------------------------------
    // Do not modify below this line
    // ------------------------------------------------------------
    println!("Hit enter to continue");

    let mut input = [0; 1];
    let _ = io::stdin().read_exact(&mut input);
}
