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

pub fn part1(input: &str) -> i32 {
    let values = parse_input(input);
    let counts = do_count(&values);

    let half_len = half_len(&values);
    let gamma_rate = counts.iter().rev().enumerate().fold(0, |acc, (i, c)| {
        if (*c as f32) > half_len {
            acc + 2i32.pow(i as u32)
        } else {
            acc
        }
    });
    let epsilon_rate = counts.iter().rev().enumerate().fold(0, |acc, (i, c)| {
        if (*c as f32) > half_len {
            acc
        } else {
            acc + 2i32.pow(i as u32)
        }
    });

    gamma_rate * epsilon_rate
}

pub fn part2(input: &str) -> i32 {
    let mut oxygen_candidates = parse_input(input);
    let mut co2_candidates = oxygen_candidates.clone();

    let mut j = 0;
    while oxygen_candidates.len() > 1 {
        let counts = do_count(&oxygen_candidates);
        let half_len = half_len(&oxygen_candidates);
        oxygen_candidates.retain(|c| {
            if counts[j] >= half_len {
                c.chars().nth(j).unwrap() == '1'
            } else {
                c.chars().nth(j).unwrap() == '0'
            }
        });

        j += 1;
    }

    let mut j = 0;
    while co2_candidates.len() > 1 {
        let counts = do_count(&co2_candidates);
        let half_len = half_len(&co2_candidates);
        co2_candidates.retain(|c| {
            if counts[j] >= half_len {
                c.chars().nth(j).unwrap() == '0'
            } else {
                c.chars().nth(j).unwrap() == '1'
            }
        });

        j += 1;
    }

    let oxygen_rating = i32::from_str_radix(oxygen_candidates[0], 2).unwrap();
    let co2_rating = i32::from_str_radix(co2_candidates[0], 2).unwrap();

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
