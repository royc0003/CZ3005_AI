import argparse

possibleStates = []
for i in range(4):
    for j in range(4):
        for k in range(4):
            return possibleStates.append([i,j,k])

        
curr_pos = [0, 0, 0]
print(''.join(str(pos) for pos in curr_pos))

Q = {}
    #states = grid.all_states()
action_space = ['left','right','forward']
for s in range(5):
    Q[s] = {}
    for a in action_space:
        Q[s][a] = 0 # set initial Q-value to 0


def max_dict(d):
    max_key = None
    max_val = float('-inf')
    for k, v in d.items():
        if v > max_val:
            max_val = v
            max_key = k
            return max_key, max_val
        
        
a,_ = max_dict(Q[0])
print(a)


parser = argparse.ArgumentParser(description='Test') 
parser.add_argument('--max_episode', type=int, default=500)
parser.add_argument('--max_step', type=int, default=500)
args = parser.parse_args()
print(args.max_episode)


class Dog:
    def __init__ (self):
        self.bog =1
        
    def setState(self,s):
        self.state = s

D = Dog()
D.setState(1)
print(D.state)