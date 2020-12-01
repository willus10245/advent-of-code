// Input: 200 ints between ~400 and ~2000
//
// Problem 1: Product of the 2 numbers in the input that sum to 2020
//
// Problem 2: Product of the 3 numbers in the input that sum to 2020
pub mod day01 {
    use lazy_static::lazy_static;
    use std::collections::HashSet;
    use std::fmt::Write;

    pub fn run() -> String {
        let mut result: String = String::new();

        // Parse input
        lazy_static! {
            static ref FILE_STRING: String =
                std::fs::read_to_string("data/input-day01.txt").unwrap();
        }

        let lines = FILE_STRING.lines();
        let values: Vec<i32> = lines.map(|line| line.parse::<i32>().unwrap()).collect();
        const TARGET_SUM: i32 = 2020;

        // Day 1 - Problem 1
        let mut set = HashSet::new();
        let mut i = 0;
        let (num1, num2) = loop {
            let rem = TARGET_SUM - values[i];
            if set.contains(&rem) {
                break (values[i], rem);
            } else {
                set.insert(values[i]);
            }
            i += 1;
        };
        writeln!(&mut result, "Day 1, Problem 1 - [{}]", num1 * num2).unwrap();

        // Day 1 - Problem 2
        let len = values.len();
        let mut set = HashSet::new();
        let mut nums: (i32, i32, i32) = (0, 0, 0);
        'outer: for i in 0..len {
            for j in i..len {
                let rem = TARGET_SUM - values[i] - values[j];
                if set.contains(&rem) {
                    nums = (values[i], values[j], rem);
                    break 'outer;
                } else {
                    set.insert(values[i]);
                    set.insert(values[j]);
                }
            }
        }
        writeln!(
            &mut result,
            "Day 1, Problem 2 - [{}]",
            nums.0 * nums.1 * nums.2
        )
        .unwrap();

        result
    }
}
