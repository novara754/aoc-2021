use crate::util;
use std::collections::HashMap;

fn simulate(fish: Vec<i32>, days: usize) -> u64 {
    fn simulate_single(mut f: i32, days: usize, known: &mut HashMap<(i32, usize), u64>) -> u64 {
        if let Some(&count) = known.get(&(f, days)) {
            count
        } else {
            let start = f;
            let mut count = 1;
            for d in 0..days {
                f -= 1;
                if f == -1 {
                    f = 6;
                    count += simulate_single(8, days - d - 1, known);
                }
            }
            known.insert((start, days), count);
            count
        }
    }

    let mut total = 0;
    let mut known = HashMap::new();
    for f in fish {
        if let Some(count) = known.get(&(f, days)) {
            total += count;
        } else {
            let count = simulate_single(f, days, &mut known);
            known.insert((f, days), count);
            total += count;
        }
    }

    total
}

pub fn part1(input: &str) -> u64 {
    let fish: Vec<_> = input.trim().split(',').map(util::parse_i32).collect();
    simulate(fish, 80)
}

pub fn part2(input: &str) -> u64 {
    let fish: Vec<_> = input.trim().split(',').map(util::parse_i32).collect();
    simulate(fish, 256)
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = r#"3,4,3,1,2"#;

    #[test]
    fn test_part1() {
        assert_eq!(part1(TEST_INPUT), 5934);
    }

    #[test]
    fn test_part2() {
        assert_eq!(part2(TEST_INPUT), 26984457539);
    }
}
