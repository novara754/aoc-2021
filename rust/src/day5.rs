use crate::util::parse_i32;

#[derive(Debug)]
struct Line(i32, i32, i32, i32);

fn parse_input(input: &str) -> Vec<Line> {
    input
        .trim()
        .lines()
        .map(|l| {
            let mut segs = l.split(" -> ");
            let mut start = segs.next().unwrap().split(',');
            let mut end = segs.next().unwrap().split(',');

            let x1 = parse_i32(start.next().unwrap());
            let y1 = parse_i32(start.next().unwrap());
            let x2 = parse_i32(end.next().unwrap());
            let y2 = parse_i32(end.next().unwrap());

            Line(x1, y1, x2, y2)
        })
        .collect()
}

pub fn order(a: i32, b: i32) -> (i32, i32) {
    if a > b {
        (b, a)
    } else {
        (a, b)
    }
}

pub fn part1(input: &str) -> i32 {
    let mut map = vec![vec![0; 1000]; 1000];

    for Line(x1, y1, x2, y2) in parse_input(input) {
        if y1 == y2 {
            let (x1, x2) = order(x1, x2);
            for x in x1..(x2 + 1) {
                map[y1 as usize][x as usize] += 1;
            }
        } else if x1 == x2 {
            let (y1, y2) = order(y1, y2);
            for y in y1..(y2 + 1) {
                map[y as usize][x1 as usize] += 1;
            }
        }
    }

    map.iter().flatten().filter(|n| **n >= 2).count() as i32
}

pub fn part2(input: &str) -> i32 {
    let mut map = vec![vec![0; 1000]; 1000];

    for l @ Line(x1, y1, x2, y2) in parse_input(input) {
        if y1 == y2 {
            let (x1, x2) = order(x1, x2);
            for x in x1..(x2 + 1) {
                map[y1 as usize][x as usize] += 1;
            }
        } else if x1 == x2 {
            let (y1, y2) = order(y1, y2);
            for y in y1..(y2 + 1) {
                map[y as usize][x1 as usize] += 1;
            }
        } else {
            let dx = x2 - x1;
            let dy = y2 - y1;
            let mx = dx.signum();
            let my = dy.signum();

            for i in 0..(dx.abs() + 1) {
                let cx = x1 + mx * i;
                let cy = y1 + my * i;
                map[cy as usize][cx as usize] += 1;
            }
        }
    }

    map.iter().flatten().filter(|n| **n >= 2).count() as i32
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = r#"
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
    "#;

    #[test]
    fn test_part1() {
        assert_eq!(part1(TEST_INPUT), 5);
    }

    #[test]
    fn test_part2() {
        assert_eq!(part2(TEST_INPUT), 12);
    }
}
