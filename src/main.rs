mod day1;

use std::{fs, io};

fn main() -> io::Result<()> {
    let solutions = [(day1::part1, day1::part2)];

    for (i, (part1, part2)) in solutions.iter().enumerate() {
        let input = fs::read_to_string("./data/day1.txt")?;
        println!("Day {}: ", i);
        println!("  Part 1: {}", part1(&input));
        println!("  Part 2: {}", part2(&input));
    }

    Ok(())
}
