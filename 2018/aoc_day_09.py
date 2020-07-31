def string_parser(game_string):
    split_str = game_string.split(";")
    n_players = int(split_str[0].split(" ")[0])
    if ":" in split_str[1]:
        split_str = split_str[1].split(":")
        last_marble = int(split_str[0].split(" ")[-2])
        high_score = int(split_str[1].split(" ")[-1])
    else:
        last_marble = int(split_str[1].split(" ")[-2])
        high_score = None

    return n_players, last_marble, high_score


def play_marbles(n_players, last_marble):
    player_scores = [0 for i in range(n_players)]
    marble_circle = [0]

    active_marble = 0
    current_player = 1
    current_marble = 1
    n_marbles = 1

    owner_of_highest_marble = 0
    highest_marble_value = 0

    while current_marble < last_marble:
        if current_marble % 23 == 0:
            active_marble = (active_marble - 7) % n_marbles
            removed_marble = marble_circle.pop(active_marble)
            marble_value = current_marble + removed_marble
            player_scores[current_player] += marble_value

            if marble_value > highest_marble_value:
                highest_marble_value = marble_value
                highest_marble_value_owner = current_player
        else:
            if (active_marble + 2) % n_marbles == 0:
                active_marble = n_marbles
            else:
                active_marble = (active_marble + 2) % n_marbles
            marble_circle.insert(active_marble, current_marble)

        current_marble += 1
        current_player = (current_player + 1) % n_players
        n_marbles = len(marble_circle)

    return player_scores


def test_marbles(n_players, last_marble, correct_value):
    player_scores = play_marbles(n_players, last_marble)
    return max(player_scores) == correct_value


if __name__ == "__main__":
    test_strings = [
        "10 players; last marble is worth 1618 points: high score is 8317",
        "13 players; last marble is worth 7999 points: high score is 146373",
        "17 players; last marble is worth 1104 points: high score is 2764",
        "21 players; last marble is worth 6111 points: high score is 54718",
        "30 players; last marble is worth 5807 points: high score is 37305",
    ]

    for i, test_str in enumerate(test_strings):
        n_players, last_marble, high_score = string_parser(test_str)
        print(
            "Test {} result = {}".format(
                i, test_marbles(n_players, last_marble, high_score)
            )
        )

    tmp = string_parser("452 players; last marble is worth 70784 points")
    n_players = tmp[0]
    last_marble = tmp[1]
    print(max(play_marbles(n_players, last_marble)))
