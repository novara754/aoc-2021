enum Command {
    Forward(i32),
    Down(i32),
    Up(i32),
}

fn parse_input(input: &'_ str) -> impl Iterator<Item = Command> + '_ {
    input.split('\n').filter(|s| !s.trim().is_empty()).map(|s| {
        let mut parts = s.split(' ');
        let cmd = parts
            .next()
            .expect("each command should have a command word");
        let dis = parts
            .next()
            .expect("each command should have a distance")
            .parse()
            .expect("each command should have a distance following it");
        match cmd {
            "forward" => Command::Forward(dis),
            "down" => Command::Down(dis),
            "up" => Command::Up(dis),
            _ => panic!("invalid command"),
        }
    })
}

pub fn part1(input: &str) -> i32 {
    let (hor, depth) = parse_input(input).fold((0, 0), |(hor, depth), cmd| match cmd {
        Command::Forward(dis) => (hor + dis, depth),
        Command::Down(dis) => (hor, depth + dis),
        Command::Up(dis) => (hor, depth - dis),
    });
    hor * depth
}

pub fn part2(input: &str) -> i32 {
    let (hor, depth, _) = parse_input(input).fold((0, 0, 0), |(hor, depth, aim), cmd| match cmd {
        Command::Forward(dis) => (hor + dis, depth + dis * aim, aim),
        Command::Down(dis) => (hor, depth, aim + dis),
        Command::Up(dis) => (hor, depth, aim - dis),
    });
    hor * depth
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = r#"
forward 5
down 5
forward 8
up 3
down 8
forward 2
    "#;

    #[test]
    fn test_part1() {
        assert_eq!(part1(TEST_INPUT), 150);
    }

    #[test]
    fn test_part2() {
        assert_eq!(part2(TEST_INPUT), 900);
    }
}
