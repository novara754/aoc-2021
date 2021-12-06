fn parse_input(input: &'_ str) -> Vec<&str> {
    input.split_whitespace().collect()
}

fn do_count(values: &[&str]) -> Vec<f32> {
    let mut counts = vec![0.0; values[0].len()];

    for value in values {
        for (i, bit) in value.chars().enumerate() {
            if bit == '1' {
                counts[i] += 1.0;
            }
        }
    }

    counts
}

fn half_len(values: &[&str]) -> f32 {
    (values.len() as f32) / 2.0
}

pub fn part1(input: &str) -> u64 {
    fn find_rate(counts: &[f32], cond: impl Fn(f32) -> bool) -> u64 {
        counts.iter().rev().enumerate().fold(0, |acc, (i, c)| {
            if cond(*c) {
                acc + 2u64.pow(i as u32)
            } else {
                acc
            }
        })
    }

    let values = parse_input(input);
    let half_len = half_len(&values);
    let counts = do_count(&values);

    let gamma_rate = find_rate(&counts, |c| c >= half_len);
    let epsilon_rate = find_rate(&counts, |c| c < half_len);

    gamma_rate * epsilon_rate
}

pub fn part2(input: &str) -> u64 {
    fn find_rating(mut candidates: Vec<&str>, cond: impl Fn(f32, f32) -> bool) -> u64 {
        let mut j = 0;
        while candidates.len() > 1 {
            let counts = do_count(&candidates);
            let half_len = half_len(&candidates);
            candidates.retain(|c: &&str| {
                let ch = c.chars().nth(j).unwrap();
                if cond(counts[j], half_len) {
                    ch == '1'
                } else {
                    ch == '0'
                }
            });
            j += 1;
        }

        u64::from_str_radix(candidates[0], 2).unwrap()
    }

    let oxygen_candidates = parse_input(input);
    let co2_candidates = oxygen_candidates.clone();

    let oxygen_rating = find_rating(oxygen_candidates, |c, half_len| c >= half_len);
    let co2_rating = find_rating(co2_candidates, |c, half_len| c < half_len);

    oxygen_rating * co2_rating
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = r#"
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
    "#;

    #[test]
    fn test_part1() {
        assert_eq!(part1(TEST_INPUT), 198);
    }

    #[test]
    fn test_part2() {
        assert_eq!(part2(TEST_INPUT), 230);
    }
}
