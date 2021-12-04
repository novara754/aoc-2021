mod day1;
mod day2;
mod day3;
mod day4;

use std::{fs, io};

type SolutionFn = for<'r> fn(&'r str) -> i32;
type Solution = (SolutionFn, SolutionFn);

fn main() -> io::Result<()> {
    let solutions: [Solution; 4] = [
        (day1::part1, day1::part2),
        (day2::part1, day2::part2),
        (day3::part1, day3::part2),
        (day4::part1, day4::part2),
    ];

    for (i, (part1, part2)) in solutions.iter().enumerate() {
        let day = i + 1;
        let input = fs::read_to_string(format!("./data/day{}.txt", day))?;
        println!("Day {}: ", day);
        println!("  Part 1: {}", part1(&input));
        println!("  Part 2: {}", part2(&input));
    }

    Ok(())
}
