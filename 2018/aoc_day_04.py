import re
from datetime import datetime

def read_data(file_path):
    with open(file_path, "r") as f:
        data = f.readlines()
    f.close()    
    return "".join(data)

def parse_data(data):
    date_times = []
    events = []
    lines = data.split('\n')

    for l in lines:
        mat = re.search(r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}', l)
        if mat:
            date_times.append(datetime.strptime(mat.group(0), 
                                               "%Y-%m-%d %H:%M"))
            events.append(l.split("] ")[1])
    
    # Order the events
    obs_verbose = [(y, x) for y, x in sorted(zip(date_times, events))]
    
    # Simplified observations
    obs_simple = []
    for oi in obs_verbose:
        ts, descr = oi

        if "begins shift" in descr:
            guard_id = int(descr.split(" ")[1].replace("#", ""))
            obs_simple.append({"guard_id" :guard_id, 
                               "chg_min" : []})

        if "falls asleep" in descr:            
            obs_simple[-1]['chg_min'].append(ts.minute)

        if "wakes up" in descr:            
            obs_simple[-1]['chg_min'].append(ts.minute)
    
    return obs_simple

def compute_time_asleep(obs):
    obs = sorted(obs, key = lambda x: x["guard_id"])
    total_time_asleep = dict()

    for oi in obs:
        guard_id, chg_min = oi['guard_id'], oi['chg_min']
        time_asleep = 0

        for i in range(len(chg_min) // 2):
            time_asleep += (chg_min[2*i+1] - chg_min[2*i])

        if guard_id not in total_time_asleep.keys():
            total_time_asleep[guard_id] = time_asleep

        else:
            total_time_asleep[guard_id] += time_asleep

    return total_time_asleep

def find_longest_time_asleep(obs):
    tot_time_asleep = compute_time_asleep(obs)
    tot_time_asleep = [(k,v) for k,v in zip(tot_time_asleep.keys(),
                                            tot_time_asleep.values())]
    tot_time_asleep = sorted(tot_time_asleep, key = lambda x: x[1])
    guard_id, time_asleep = tot_time_asleep[-1]
    return (guard_id, time_asleep)

def time_asleep_per_minute(guard_id, obs):
    min_asleep = [0 for i in range(59)]
    for oi in obs:
        if oi['guard_id'] == guard_id:
            chg_min = oi['chg_min']            
            for i in range(len(chg_min) // 2):
                sleep_start = chg_min[2*i]
                sleep_end = chg_min[2*i+1]
                for j in range(sleep_start, sleep_end):
                    min_asleep[j] += 1
    return min_asleep

def solve_part_1(obs):
    guard_id, time_asleep = find_longest_time_asleep(obs)
    tapm = time_asleep_per_minute(guard_id, obs)
    return guard_id * tapm.index(max(tapm))

def solve_part_2(obs):
    guard_ids = set()    
    for oi in obs:
        guard_ids.add(oi['guard_id'])
    guard_ids = list(guard_ids)
    n_guards = len(guard_ids)

    tapm_for_guard = []
    for guard_id in guard_ids:
        tapm_for_guard.append(time_asleep_per_minute(guard_id, obs))
    
    freq_result = [[] for i in range(59)]
    for i in range(59):
        tapm_i = [tapm_for_guard[j][i] for j in range(n_guards)]
        longest_time_i = max(tapm_i)
        idx_most_freq_i = tapm_i.index(longest_time_i)        
        guard_most_freq_i = guard_ids[idx_most_freq_i]        
        freq_result[i] = [guard_most_freq_i, longest_time_i]
    
    # Longest time each minute
    tapm = [x[1] for x in freq_result]

    # Minute with longest time
    most_freq_min = tapm.index(max(tapm))
    
    # Guard who achieves that longest time
    guard_at_most_freq = freq_result[most_freq_min][0]

    return most_freq_min * guard_at_most_freq

if __name__ == "__main__":

    test_input = '''
    [1518-11-01 00:00] Guard #10 begins shift
    [1518-11-01 00:05] falls asleep
    [1518-11-01 00:25] wakes up
    [1518-11-01 00:30] falls asleep
    [1518-11-01 00:55] wakes up
    [1518-11-01 23:58] Guard #99 begins shift
    [1518-11-02 00:40] falls asleep
    [1518-11-02 00:50] wakes up
    [1518-11-03 00:05] Guard #10 begins shift
    [1518-11-03 00:24] falls asleep
    [1518-11-03 00:29] wakes up
    [1518-11-04 00:02] Guard #99 begins shift
    [1518-11-04 00:36] falls asleep
    [1518-11-04 00:46] wakes up
    [1518-11-05 00:03] Guard #99 begins shift
    [1518-11-05 00:45] falls asleep
    [1518-11-05 00:55] wakes up
    '''
    
    obs = parse_data(test_input)    
    print("Part 1 (Test) : {}".format(solve_part_1(obs)))
    print("Part 2 (Test) : {}".format(solve_part_2(obs)))

    obs = parse_data(read_data("./input/aoc_04.txt"))
    print("Part 1 : {}".format(solve_part_1(obs)))
    print("Part 2 : {}".format(solve_part_2(obs)))

    

    
