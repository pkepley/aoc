import numpy as np


def read_input(input_path):
    f = open(input_path, "r")
    raw_data = list(f)
    f.close()

    moon_positions = np.zeros((len(raw_data), 3))
    for k, raw_datum in enumerate(raw_data):
        x, y, z = (
            raw_datum.replace("<", "").replace(">", "").replace("\n", "").split(",")
        )
        x = int(x.split("=")[1])
        y = int(y.split("=")[1])
        z = int(z.split("=")[1])
        moon_positions[k, :] = np.array([x, y, z], dtype=np.int)

    return moon_positions


def kinetic_energies(moon_velocities):
    return np.sum(np.abs(moon_velocities), axis=1).astype(np.int)


def potential_energies(moon_positions):
    return np.sum(np.abs(moon_positions), axis=1).astype(np.int)


def total_energy(moon_positions, moon_velocities):
    n_moons = moon_positions.shape[0]
    ks = kinetic_energies(moon_velocities).reshape((n_moons, 1))
    ps = potential_energies(moon_positions).reshape((n_moons, 1))
    return np.dot(ks.T, ps).flatten()[0]


def simulate_motion(moon_positions, n_steps=1000, logger=None):
    n_moons = len(moon_positions)
    moon_velocities = np.zeros(moon_positions.shape)

    if logger is not None:
        logger(moon_positions, moon_velocities)

    for k in range(n_steps):
        for moon_1 in range(n_moons):
            for moon_2 in range(moon_1 + 1, n_moons):
                vel_updt = np.sign(
                    moon_positions[moon_1, :] - moon_positions[moon_2, :]
                ).astype(np.int)
                moon_velocities[moon_1, :] = moon_velocities[moon_1, :] - vel_updt
                moon_velocities[moon_2, :] = moon_velocities[moon_2, :] + vel_updt

        moon_positions = moon_positions + moon_velocities

        if logger is not None:
            logger(moon_positions, moon_velocities)

    return moon_positions, moon_velocities


class position_logger:
    def __init__(self):
        self.trajectory = []

    def log_positions(self, ps, vs):
        self.trajectory.append(ps)


if __name__ == "__main__":
    moon_positions = np.array(
        [[-1, 0, 2], [2, -10, -7], [4, -8, 8], [3, 5, -1]], dtype=np.int
    )
    test_result = np.array(
        [[2, 1, -3], [1, -8, 0], [3, -6, 1], [2, 0, 4]], dtype=np.int
    )
    ps, vs = simulate_motion(moon_positions, n_steps=10)
    assert np.array_equal(ps, test_result)
    assert total_energy(ps, vs) == 179

    moon_positions = read_input("./input/input_day_12.txt")
    ps, vs = simulate_motion(moon_positions, n_steps=1000)
    s1 = total_energy(ps, vs)
    print("Solution part 1: {}".format(s1))
