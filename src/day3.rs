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
    let half_len = half_len(&values);
    let counts = do_count(&values);

    fn reducer(half_len: f32, flipped: bool) -> impl FnMut(i32, (usize, &f32)) -> i32 {
        move |acc, (i, c)| {
            if *c > half_len {
                if !flipped {
                    acc + 2i32.pow(i as u32)
                } else {
                    acc
                }
            } else {
                if flipped {
                    acc + 2i32.pow(i as u32)
                } else {
                    acc
                }
            }
        }
    }

    let gamma_rate = counts
        .iter()
        .rev()
        .enumerate()
        .fold(0, reducer(half_len, false));
    let epsilon_rate = counts
        .iter()
        .rev()
        .enumerate()
        .fold(0, reducer(half_len, true));

    gamma_rate * epsilon_rate
}

pub fn part2(input: &str) -> i32 {
    let mut oxygen_candidates = parse_input(input);
    let mut co2_candidates = oxygen_candidates.clone();

    fn pred(
        counts: &'_ [f32],
        half_len: f32,
        flipped: bool,
        j: usize,
    ) -> impl FnMut(&&str) -> bool + '_ {
        move |c: &&str| {
            let ch = c.chars().nth(j).unwrap();
            if counts[j] >= half_len {
                ch == if !flipped { '1' } else { '0' }
            } else {
                ch == if flipped { '1' } else { '0' }
            }
        }
    }

    let mut j = 0;
    while oxygen_candidates.len() > 1 {
        let counts = do_count(&oxygen_candidates);
        let half_len = half_len(&oxygen_candidates);
        oxygen_candidates.retain(pred(&counts, half_len, false, j));
        j += 1;
    }

    let mut j = 0;
    while co2_candidates.len() > 1 {
        let counts = do_count(&co2_candidates);
        let half_len = half_len(&co2_candidates);
        co2_candidates.retain(pred(&counts, half_len, true, j));
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
