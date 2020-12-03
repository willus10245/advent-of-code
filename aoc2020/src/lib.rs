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

// Input: 1000 passwords of dubious validity along with the password policy details when it was set
//
// Problem 1: How many passwords are valid according to they're corresponding policy?
//
// Problem 2: Policy numbers are actually indicies, not counts. How many valid now?
pub mod day02 {
    use lazy_static::lazy_static;
    use regex::{Captures, Regex};
    use std::fmt::Write;

    pub fn run() -> String {
        let mut result: String = String::new();

        // Parse input
        lazy_static! {
            static ref FILE_STRING: String =
                std::fs::read_to_string("data/input-day02.txt").unwrap();
        }

        let lines = FILE_STRING.lines();

        // Day 2 - Problem 1
        let p_and_p_regex =
            Regex::new(r"(?P<min>\d{1,2})-(?P<max>\d{1,2}) (?P<char>.): (?P<pass>.+)").unwrap();
        let policies_and_passwords: Vec<Captures> = lines
            .map(|line| p_and_p_regex.captures(line).unwrap())
            .collect();

        let valid_password_count = policies_and_passwords
            .iter()
            .map(|caps| {
                let min: i32 = caps.name("min").unwrap().as_str().parse().unwrap();
                let max: i32 = caps.name("max").unwrap().as_str().parse().unwrap();
                let num_chars = caps
                    .name("pass")
                    .unwrap()
                    .as_str()
                    .matches(caps.name("char").unwrap().as_str())
                    .collect::<Vec<_>>()
                    .len();

                min <= (num_chars as i32) && (num_chars as i32) <= max
            })
            .filter(|is_valid| *is_valid)
            .count();
        writeln!(&mut result, "Day 2, Problem 1 - [{}]", valid_password_count).unwrap();

        // Day 2 - Problem 2
        let real_valid_password_count = policies_and_passwords
            .iter()
            .map(|caps| {
                let pos1: usize = caps.name("min").unwrap().as_str().parse().unwrap();
                let pos2: usize = caps.name("max").unwrap().as_str().parse().unwrap();
                let character = caps.name("char").unwrap().as_str();
                let pass = caps.name("pass").unwrap().as_str();
                let pass_chars = pass.chars();

                let pos1char = pass_chars.clone().nth(pos1 - 1).unwrap();
                let pos2char = pass_chars.clone().nth(pos2 - 1).unwrap();
                let charchar = character.chars().next().unwrap();

                (pos1char == charchar) ^ (pos2char == charchar)
            })
            .filter(|is_valid| *is_valid)
            .count();
        writeln!(
            &mut result,
            "Day 2, Problem 1 - [{}]",
            real_valid_password_count
        )
        .unwrap();

        result
    }
}

// Input: grid of (.) representing open spaces and (#) representing trees
//
// Problem 1: starting at top left, how many trees would you hit going to the bottom with
// a slope of 1/3
//
// Problem 2: Find product of trees hit when descending with slopes of 1, 1/3, 1/5, 1/7, and 2
pub mod day03 {
    use lazy_static::lazy_static;
    use std::fmt::Write;

    pub fn run() -> String {
        let mut result: String = String::new();

        // Parse input
        lazy_static! {
            static ref FILE_STRING: String =
                std::fs::read_to_string("data/input-day03.txt").unwrap();
        }

        const TREE: char = '#';
        let lines: Vec<&str> = FILE_STRING.lines().collect();
        let width = lines[0].len();

        // Day 3 - Problem 1
        let mut curr_x = 0;
        let mut trees_hit = 0;

        for line in lines.clone() {
            if line.chars().nth(curr_x).unwrap() == TREE {
                trees_hit += 1;
            }
            curr_x = (curr_x + 3) % width;
        }

        writeln!(&mut result, "Day 3, Problem 1 - [{}]", trees_hit).unwrap();

        // Day 3 - Problem 2
        let slopes = vec![1, 5, 7];
        let mut trees_hit_vec: Vec<i64> = slopes
            .iter()
            .map(|slope| {
                let mut trees_hit = 0;
                let mut curr_x = 0;

                for line in lines.clone() {
                    if line.chars().nth(curr_x).unwrap() == TREE {
                        trees_hit += 1;
                    }
                    curr_x = (curr_x + slope) % width;
                }

                trees_hit
            })
            .collect();

        let mut trees_hit_weird = 0;
        let mut curr_x = 0;

        for (i, line) in lines.clone().iter().enumerate() {
            if i % 2 == 0 {
                if line.chars().nth(curr_x).unwrap() == TREE {
                    trees_hit_weird += 1;
                }
                curr_x = (curr_x + 1) % width;
            }
        }

        trees_hit_vec.append(&mut vec![trees_hit_weird, trees_hit]);

        let total_trees_hit = trees_hit_vec
            .iter()
            .fold(1, |acc, trees_hit| trees_hit * acc);

        writeln!(&mut result, "Day 3, Problem 2 - [{}]", total_trees_hit).unwrap();

        result
    }
}
