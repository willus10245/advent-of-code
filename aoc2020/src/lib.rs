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
                let min: i32 = caps["min"].parse().unwrap();
                let max: i32 = caps["max"].parse().unwrap();
                let num_chars = caps["pass"]
                    .matches(&caps["char"])
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
                let pos1: usize = caps["min"].parse().unwrap();
                let pos2: usize = caps["max"].parse().unwrap();
                let character = &caps["char"];
                let pass = &caps["pass"];
                let pass_chars = pass.chars();

                let pos1char = pass_chars.clone().nth(pos1 - 1).unwrap();
                let pos2char = pass_chars.clone().nth(pos2 - 1).unwrap();
                let charchar = character.chars().next().unwrap();

                (pos1char == charchar) != (pos2char == charchar)
            })
            .filter(|is_valid| *is_valid)
            .count();
        writeln!(
            &mut result,
            "Day 2, Problem 2 - [{}]",
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

// Input: string containing several hundred sets of passport data as key:value pairs
//
// Problem 1: How many passwords are valid? (contain all required fields)
//
// Problem 2: How many passwords are valid? (strict data validation)
pub mod day04 {
    use lazy_static::lazy_static;
    use regex::Regex;
    use std::collections::HashMap;
    use std::fmt::Write;

    fn from_passport_str(pass_str: &&str) -> HashMap<String, String> {
        let mut data_map = HashMap::new();

        for kv in pass_str.replace("\n", " ").split(" ") {
            let list = kv.split(":").collect::<Vec<_>>();
            data_map.insert(String::from(list[0]), String::from(list[1]));
        }

        data_map
    }

    pub fn run() -> String {
        let mut result: String = String::new();

        // Parse input
        lazy_static! {
            static ref FILE_STRING: String =
                std::fs::read_to_string("data/input-day04.txt").unwrap();
        }

        let passport_strings = FILE_STRING.split("\n\n").collect::<Vec<_>>();

        // Day 4 - Problem 1
        let valid_count = passport_strings
            .iter()
            .map(|pass_str| is_valid(pass_str))
            .filter(|is_valid| *is_valid)
            .count();
        writeln!(&mut result, "Day 4, Problem 1 - [{}]", valid_count).unwrap();

        // Day 4 - Problem 2
        let real_valid_count = passport_strings
            .iter()
            .map(|pass_str| from_passport_str(pass_str))
            .map(|data_map| strict_is_valid(data_map))
            .filter(|is_valid| *is_valid)
            .count();
        writeln!(&mut result, "Day 4, Problem 2 - [{}]", real_valid_count).unwrap();

        result
    }

    fn is_valid(passport_string: &&str) -> bool {
        let required_fields = vec!["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"];
        required_fields
            .iter()
            .fold(true, |acc, field| acc && passport_string.contains(field))
    }

    fn strict_is_valid(pass_data: HashMap<String, String>) -> bool {
        let required_fields = vec!["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"];
        required_fields
            .iter()
            .cloned()
            .map(|field| match pass_data.get(&String::from(field)) {
                None => false,
                Some(value) => match field {
                    "byr" => match value.parse::<u32>() {
                        Ok(n) => n >= 1920 && n <= 2002,
                        _ => false,
                    },
                    "iyr" => match value.parse::<u32>() {
                        Ok(n) => n >= 2010 && n <= 2020,
                        _ => false,
                    },
                    "eyr" => match value.parse::<u32>() {
                        Ok(n) => n >= 2020 && n <= 2030,
                        _ => false,
                    },
                    "hgt" => match value {
                        value if value.ends_with("cm") => {
                            match value.trim_end_matches("cm").parse::<u32>() {
                                Ok(n) => n >= 150 && n <= 193,
                                _ => false,
                            }
                        }
                        value if value.ends_with("in") => {
                            match value.trim_end_matches("in").parse::<u32>() {
                                Ok(n) => n >= 59 && n <= 76,
                                _ => false,
                            }
                        }
                        _ => false,
                    },
                    "hcl" => Regex::new(r"^#[[:xdigit:]]{6}$").unwrap().is_match(value),
                    "ecl" => {
                        ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(&&value[..])
                    }
                    "pid" => value.len() == 9,
                    _ => false,
                },
            })
            .fold(true, |acc, valid| acc && valid)
    }
}

// Input: 868 strings representing airplane seat assignments
//
// Problem: Highest seat id
//
// Probelm: find missing seat id (it's ours!)
pub mod day05 {
    use lazy_static::lazy_static;
    use std::fmt::Write;

    pub fn run() -> String {
        let mut result: String = String::new();

        // Parse input
        lazy_static! {
            static ref FILE_STRING: String =
                std::fs::read_to_string("data/input-day05.txt").unwrap();
        }

        let mut seat_ids = FILE_STRING
            .lines()
            .map(|line| {
                let mut id = 0;
                for (i, c) in line.chars().rev().enumerate() {
                    match c {
                        'B' => id += 2usize.pow(i as u32),
                        'R' => id += 2usize.pow(i as u32),
                        _ => (),
                    }
                }
                id
            })
            .collect::<Vec<_>>();

        // Day 5 - Problem 1
        let highest_id = seat_ids.iter().fold(0, |highest, id| highest.max(*id));
        writeln!(&mut result, "Day 5, Problem 1 - [{}]", highest_id).unwrap();
        // Day 5 - Problem 2
        seat_ids.sort();
        let mut missing: usize = 0;
        for n in seat_ids[0]..*seat_ids.last().unwrap() {
            if !seat_ids.contains(&n) {
                if seat_ids.contains(&(&n + 1)) && seat_ids.contains(&(&n - 1)) {
                    missing = n;
                }
            }
        }
        writeln!(&mut result, "Day 5, Problem 2 - [{}]", missing).unwrap();

        result
    }
}
