def get_input(path):
    f=open(path)    
    out = f.readline()
    out = [int(c) for c in out.replace('\n','')]
    f.close()

    return out

def image_layers(img_flat, n_row, n_col):
    img_size = n_row * n_col    
    n_layers = int(len(img_flat) / img_size)
    layers = []
    
    for i in range(n_layers):
        layer_flat = img_flat[i*img_size:(i+1)*img_size]
        layer = [layer_flat[r*n_col:(r+1)*n_col] for r in range(0, n_row)]
        layers.append(layer)

    return layers

def decode_image(img_flat, n_row, n_col):
    layers = image_layers(img_flat, n_row, n_col)
    n_layers = len(layers)

    # Get the image
    img = [[2 for c in range(n_col)] for r in range(n_row)]
    for r in range(n_row):
        for c in range(n_col):
            for l in range(n_layers):
                if layers[l][r][c] != 2:
                    img[r][c] = layers[l][r][c]
                    break                
    return img

def solve_part_1(img_flat, n_row, n_col):
    layers = image_layers(img_flat, n_row, n_col)
    
    n_zeros = [sum([sum([1 if x == 0 else 0 for x in r]) for r in l]) for l in layers]
    n_ones  = [sum([sum([1 if x == 1 else 0 for x in r]) for r in l]) for l in layers]
    n_twos  = [sum([sum([1 if x == 2 else 0 for x in r]) for r in l]) for l in layers]    

    fewest_zeros_idx = n_zeros.index(int(min(n_zeros)))

    return n_ones[fewest_zeros_idx] * n_twos[fewest_zeros_idx]

def solve_part_2(img_flat, n_row, n_col):
    img = decode_image(img_flat, n_row, n_col)

    # Print the image
    msg = ''
    for row in img:
        msg += (''.join(['*' if x == 1 else ' ' for x in row]) + '\n')

    return msg
        
if __name__ == '__main__':
    inpt = get_input('./input/input_day_8.txt')
    s1 = solve_part_1(inpt, n_row = 6, n_col = 25)
    s2 = solve_part_2(inpt, n_row = 6, n_col = 25)
    print("Solution to Part 1: {}".format(s1))                       
    print("Solution to part 2:\n{}".format(s2))

