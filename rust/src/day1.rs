fn parse_input(input: &str) -> Vec<i32> {
    input
        .split_whitespace()
        .map(|n| n.parse().expect("file should contain only numbers"))
        .collect()
}

pub fn part1(input: &str) -> i32 {
    parse_input(input)
        .windows(2)
        .filter(|w| w[0] < w[1])
        .count() as i32
}

pub fn part2(input: &str) -> i32 {
    let sums: Vec<i32> = parse_input(input)
        .windows(3)
        .map(|w| w.iter().sum())
        .collect();
    sums.windows(2).filter(|w| w[0] < w[1]).count() as i32
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = r#"
199
200
208
210
200
207
240
269
260
263
    "#;

    #[test]
    fn test_part1() {
        assert_eq!(part1(TEST_INPUT), 7);
    }

    #[test]
    fn test_part2() {
        assert_eq!(part2(TEST_INPUT), 5);
    }
}
