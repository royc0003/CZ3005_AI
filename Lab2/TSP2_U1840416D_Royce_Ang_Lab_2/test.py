import argparse

import random

from environment import TreasureCube
import numpy as np
import math
import matplotlib.pyplot as plt



# you need to implement your agent based on one RL algorithm
class RandomAgent(object):
    def __init__(self):
        self.action_space = ['left','right','forward','backward','up','down'] # in TreasureCube
        self.biggest_change =0
        

    def take_action(self, state):
        action = random.choice(self.action_space)
        return action
    def random_greedy_action(self, state_key, eps=0.01):
        """
      Note: greedy_epsilon function also note that state is an array
      The agent takes random actions for probability ε and greedy action for probability (1-ε).
      """
        a,_ = self.max_dict(state_key)
        p = np.random.random()
        if p < (1 - eps):
            return a
        else:
            return np.random.choice(self.action_space)
    def setQ(self,q):
        self.Q = q
    def setUpdate_count(self, update_counts):
        self.update_counts = update_counts
    def getBiggestChange(self):
        return self.biggest_change
    def max_dict(self,d):
      # returns the argmax (key) and max (value) from a dictionary
      # put this into a function since we are using it so often
        max_key = None
        max_val = float('-inf')
        for k, v in d.items():
            if v > max_val:
                max_val = v
                max_key = k
        return max_key, max_val

    # implement your train/update function to update self.V or self.Q
    # you should pass arguments to the train function
    def train(self, state, action, next_state, reward):
        """
        Note: state == current state e.g. [0,0,0]
        """
        ALPHA = 0.5 #learning rate
        GAMMA = 0.99 #discount factor
        #implement the normal q_algorithm here
        old_qsa = self.Q[state][action]
        a2, max_q_s2a2 = self.max_dict(self.Q[next_state])
        self.Q[state][action] = old_qsa + ALPHA*(reward + GAMMA*max_q_s2a2 - old_qsa)

        self.biggest_change = max(self.biggest_change, np.abs(old_qsa - self.Q[state][action]))
        self.update_counts[state] = self.update_counts.get(state,0) + 1
        
        
        

    def createAllPossibleStates(self):
        """
        This creates all 64 permutations of states from [0,0,0] to [3,3,3]
        """
        possibleStates = []
        for i in range(4):
            for j in range(4):
                for k in range(4):
                    possibleStates.append((i,j,k))
        return possibleStates
    def print_policy(self,P):
        for i in range(4):
            print("---------------------------")
            for j in range(4):
                for k in range(4):
                    if(i == 3 and j == 3 and k ==3):
                        a = 'GOAL'
                        
                    
                    else:
                        a = P.get((i,j,k), ' ')
                    
                    print("  %s  |" % a, end="")
                print("")

    def print_values(self, V):
        for i in range(4):
            print("---------------------------")
            for j in range(4):
                for k in range(4):
                    v = V.get((i,j,k), 0)
                    if v >= 0:
                        print(" %.4f|" % v, end="")
                    else:
                        print("%.4f|" % v, end="") # -ve sign takes up an extra space
                print("")
    
def test_cube(max_episode, max_step):
    env = TreasureCube(max_step=max_step)
    agent = RandomAgent()
    deltas = []
    biggest_change=0
    episode_num_list = []
    episode_reward_list = []
    #sets all possible states in the given environment
    possible_states = agent.createAllPossibleStates()
    episode_array = []
    
    # set all Q-values
    Q = {}
    #states = grid.all_states()
    for s in possible_states:
        Q[s] = {}
        for a in agent.action_space:
            Q[s][a] = 0 # set initial Q-value to 0
    print(Q)
    agent.setQ(Q) #sets Q for easier computation
    
    #Let's also keep track of how many times Q[s] has been updated
    update_counts = {}
    update_counts_sa = {}
    for s in possible_states:
        update_counts_sa[s] = {}
        for a in agent.action_space:
            update_counts_sa[s][a] = 1.0
            
    agent.setUpdate_count(update_counts)
    for epsisode_num in range(0, max_episode):
        state = env.reset()
        state = tuple(state)
        terminate = False
        t = 0
        episode_reward = 0
        #getting the max action
        #a, _ = max_dict[Q[s]]
        while not terminate:
            #action = agent.take_action(state)
            action = agent.random_greedy_action(Q[state], eps=0.01)
            reward, terminate, next_state = env.step(action)
            next_state = tuple(next_state)
            episode_reward += reward
            # you can comment the following two lines, if the output is too much
            env.render() # comment
            print(f'step: {t}, action: {action}, reward: {reward}') # comment
            t += 1
            agent.train(state, action, next_state, reward)
            deltas.append(agent.getBiggestChange())
            state = next_state
        #episode_num_list.append(epsisode_num)
        episode_reward_list.append(episode_reward)
        print(f'epsisode: {epsisode_num+1}, total_steps: {t} episode reward: {episode_reward}')
        #print("episode: ", epsisode_num, " total_steps:", t, " episode_reward:", episode_reward )
        #store in some value here to plot the episode_reward vs episode_num
    policy = {}
    V = {}
    for s in possible_states:
        a, max_q = agent.max_dict(Q[s])
        policy[s] = a
        V[s] = max_q
    print("**************************************************")

    print("----Q-Table-FULL------")
    for s in possible_states:
        print(s, Q[s])
    print("**************************************************")

    print("----Q-Table-Values------")
    agent.print_values(V)
    print("**************************************************")

    print("----Policy-Table------")
    agent.print_policy(policy)
    print("**************************************************")
    print("----Proportion of time spent updating each part of Q------")
    total = np.sum(list(update_counts.values()))
    for k,v in update_counts.items():
        update_counts[k] = float(v)/total
    agent.print_values(update_counts)
    #plt.plot(sorted(deltas,reverse=True))
    #plt.show()
   # fig = plt.figure()
    #ax = plt.axes()
    index = range(1,max_episode+1)
    plt.plot(index,episode_reward_list )
    plt.ylabel('Rewards')
    plt.xlabel('Episodes')
    plt.show()
   
    

#{(0,0,0):{'Left':0,...}}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Test')
    parser.add_argument('--max_episode', type=int, default=500)
    parser.add_argument('--max_step', type=int, default=500)
    args = parser.parse_args()

    test_cube(args.max_episode, args.max_step)
    #test_cube(500,500)

#test_cube(10,500)