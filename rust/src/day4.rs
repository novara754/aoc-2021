#[derive(Debug)]
struct Board {
    grid: [[(i32, bool); 5]; 5],
    result: Option<i32>,
}

impl Board {
    fn new(grid: &[Vec<i32>]) -> Self {
        let mut board = Self {
            grid: [[(0, false); 5]; 5],
            result: None,
        };
        for (i, r) in grid.iter().enumerate() {
            for (j, v) in r.iter().enumerate() {
                board.grid[i][j].0 = *v;
            }
        }
        board
    }

    fn mark(&mut self, num: i32) -> Option<i32> {
        for i in 0..5 {
            for j in 0..5 {
                if self.grid[i][j].0 == num {
                    self.grid[i][j].1 = true;
                }

                let row_marked = self.grid[i].iter().all(|(_, b)| *b);
                let col_marked = self.grid.iter().all(|r| r[j].1);

                if row_marked || col_marked {
                    self.result = Some(
                        self.grid
                            .iter()
                            .flat_map(|r| {
                                r.iter()
                                    .filter_map(|(n, b)| if !b { Some(n) } else { None })
                            })
                            .sum(),
                    );
                    return self.result;
                }
            }
        }

        None
    }
}

fn parse_input(input: &'_ str) -> (Vec<i32>, Vec<Board>) {
    let input = input.trim();
    let mut lines = input.lines();

    let numbers: Vec<i32> = lines
        .next()
        .unwrap()
        .split(',')
        .map(|n| n.parse().unwrap())
        .collect();

    let mut boards = vec![];
    while let Some(_) = lines.next() {
        let mut rows = vec![];
        for _ in 0..5 {
            rows.push(
                lines
                    .next()
                    .unwrap()
                    .split_whitespace()
                    .map(|c| c.parse().unwrap())
                    .collect(),
            );
        }
        boards.push(Board::new(&rows));
    }

    (numbers, boards)
}

pub fn part1(input: &str) -> i32 {
    let (numbers, mut boards) = parse_input(input);

    (|| {
        for num in numbers {
            for board in &mut boards {
                if let Some(sum) = board.mark(num) {
                    return sum * num;
                }
            }
        }
        unreachable!();
    })()
}

pub fn part2(input: &str) -> i32 {
    let (numbers, mut boards) = parse_input(input);

    (|| {
        for num in numbers {
            for board in &mut boards {
                board.mark(num);
            }
            if boards.len() == 1 {
                return boards[0].result.unwrap() * num;
            }
            boards.retain(|b| b.result.is_none());
        }
        unreachable!();
    })()
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = r#"
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
    "#;

    #[test]
    fn test_part1() {
        assert_eq!(part1(TEST_INPUT), 4512);
    }

    #[test]
    fn test_part2() {
        assert_eq!(part2(TEST_INPUT), 1924);
    }
}
