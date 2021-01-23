import itertools
import pandas as pd
import random
import tvec
import sys

# ------------------------------------------------------------------------------
# HOW TO USE:
# 1. run pokemons.py to construct 'league_pokemons.csv' <- expensive calculations
# 2. run trainers.py to construct 'league_trainers.csv'
# 3. run league.py to construct 'league_results.csv'
# ------------------------------------------------------------------------------

def get_trainers_indexes(id1, id2, df):
    #dfb = next(iter(df[df['A']==5].index), 'no match') # stack over flow
    index1 = int(df[df['trainerID']==id1].index[0])
    index2 = int(df[df['trainerID']==id2].index[0])
    #print(index1,index2)
    return index1, index2

def get_pok0(index, df):
    pok = dict()
    pok['id'] = df.loc[index, 'pok0_id']
    pok['type1'] = df.loc[index, 'pok0_type1']
    pok['type2'] = df.loc[index, 'pok0_type2']
    pok['cp'] = int(df.loc[index, 'pok0_cp'])
    pok['modcp'] = int(df.loc[index, 'pok0_modcp'])
    pok['speed'] = int(df.loc[index, 'pok0_speed'])
    pok['isaccess'] = df.loc[index, 'pok0_isaccess']
    return pok

def get_pok(index, df, opponent):
    for i in range(1,6):
        key = 'pok'+str(i)
        key_access = key+'_isaccess'
        if key_access:
            pok = dict()
            pok['id'] = df.loc[index, key+'_id']
            pok['type1'] = df.loc[index, key+'_type1']
            pok['type2'] = df.loc[index, key+'_type2']
            pok['cp'] = int(df.loc[index, key+'_cp'])
            pok['modcp'] = int(df.loc[index, key+'_modcp'])
            pok['speed'] = int(df.loc[index, key+'_speed'])
            pok['isaccess'] = df.loc[index, key+'_isaccess']
            pok, opponent = fight(pok, opponent, T)
            if pok['isaccess']:
                return pok
    return None

def set_notaccess(pok, position, index, df):
    key = 'pok'+str(position)+'_isaccess'
    df.loc[index, key] = False
    return df



def mod(pok1_type1, pok1_type2, pok2_type1, pok2_type2, T):
    mod1 = tvec.modifier(pok1_type1, pok2_type1, T)
    mod2 = tvec.modifier(pok1_type1, pok2_type2, T)
    mod3 = tvec.modifier(pok1_type2, pok2_type1, T)
    mod4 = tvec.modifier(pok1_type2, pok2_type2, T)
    return mod1, mod2, mod3, mod4

def fight(pok1, pok2, T):
    max_CP = 10000
    # faster attacks first
    if pok1['speed'] > pok2['speed']:
        #print('tr1 atakuje pierwszy', pok1['speed'], pok2['speed'])
        mod1, mod2, mod3, mod4 = mod(pok1['type1'], pok1['type2'], pok2['type1'], pok2['type2'], T)
        pok1['modcp'] = mod1*mod2*mod3*mod4*pok1['cp']
    elif pok1['speed'] < pok2['speed']:
        #print('tr2 atakuje pierwszy', pok1['speed'], pok2['speed'])
        mod1, mod2, mod3, mod4 = mod(pok2['type1'], pok2['type2'], pok1['type1'], pok1['type2'], T)
        pok2['modcp'] = mod1*mod2*mod3*mod4*pok2['cp']
    else:
        #print('ten sam speed', pok1['speed'], pok2['speed'])
        choice = random.choice([1, 2])
        if choice == 1:
            #print('tr1 atakuje pierwszy', pok1['speed'], pok2['speed'])
            mod1, mod2, mod3, mod4 = mod(pok1['type1'], pok1['type2'], pok2['type1'], pok2['type2'], T)
            pok1['modcp'] = mod1*mod2*mod3*mod4*pok1['cp']
        else:
            #print('tr2 atakuje pierwszy', pok1['speed'], pok2['speed'])
            mod1, mod2, mod3, mod4 = mod(pok2['type1'], pok2['type2'], pok1['type1'], pok1['type2'], T)
            pok2['modcp'] = mod1*mod2*mod3*mod4*pok2['cp']

    if pok1['modcp'] > max_CP:
        pok1['modcp'] = max_CP
    if pok2['modcp'] > max_CP:
        pok2['modcp'] = max_CP

    if pok1['modcp'] == pok2['modcp']:
        if pok1['speed'] < pok2['speed']:
            pok1['isaccess'] = False
        elif pok1['speed'] > pok2['speed']:
            pok2['isaccess'] = False
        else:
            choice = random.choice([1,2])
            if choice == 1:
                pok1['isaccess'] = False
            if choice == 2:
                pok2['isaccess'] = False
    elif pok1['modcp'] < pok2['modcp']:
        pok1['isaccess'] = False
    else:
        pok2['isaccess'] = False

    pok1['modcp'] = pok1['cp']
    pok2['modcp'] = pok2['cp']
    return pok1, pok2

def duel(trainerID1, trainerID2, trainers, T):
    # duel
    index1, index2 = get_trainers_indexes(trainerID1, trainerID2, trainers)
    i = 0
    while True:
        if i == 10: break

        if i == 0:
            pok1 = get_pok0(index1, trainers)
            pok2 = get_pok0(index2, trainers)
            pok1, pok2 = fight(pok1, pok2, T)
            #print('tr1, winner', pok1['isaccess'], 'tr2, winner', pok2['isaccess'])
            if pok1['isaccess']:
                trainers = set_notaccess(pok2, i, index2, trainers)
            else:
                trainers = set_notaccess(pok1, i, index1, trainers)
            #print(trainers['pok0_isaccess'].head())
        else:
            if not pok1['isaccess']:
                #print('tr1 dobiera')
                pok1 = get_pok(index1, trainers, pok2)
                if pok1 == None:
                    #print('tr1 nie ma jak odpowiedzieć, koniec walki')
                    trainers.loc[index2, 'wins']+=1
                    break
                pok1, pok2 = fight(pok1, pok2, T)
                #print('tr1, winner', pok1['isaccess'], 'tr2, winner', pok2['isaccess'])
                if pok1['isaccess']:
                    trainers = set_notaccess(pok2, i, index2, trainers)
                else:
                    trainers = set_notaccess(pok1, i, index1, trainers)
            else:
                #print('tr2 dobiera')
                pok2 = get_pok(index2, trainers, pok1)
                if pok2 == None:
                    #print('tr2 nie ma jak odpowiedzieć, koniec walki')
                    trainers.loc[index1, 'wins']+=1
                    break
                #print('tr1, winner', pok1['isaccess'], 'tr2, winner', pok2['isaccess'])
                if pok1['isaccess']:
                    trainers = set_notaccess(pok2, i, index2, trainers)
                else:
                    trainers = set_notaccess(pok1, i, index1, trainers)
        i+=1

    for i in range(0,6):
        key = 'pok'+str(i)+'_isaccess'
        trainers.loc[index1, key] = True
        trainers.loc[index2, key] = True
    try:
        del trainers['pok6_isaccess']
        del trainers['pok7_isaccess']
        del trainers['pok8_isaccess']
        del trainers['pok9_isaccess']
    except:
        pass
    return trainers


def get_limes_id(trainers):
    stat_trainer = trainers.tail(1)
    stat_id = stat_trainer['trainerID'].to_list()
    rand_id = stat_id[0]-1 #-1 because we have two trainers: rand and stat
    return rand_id

def construct_combinations(trainerID):
    n = 2
    combinations = []
    combinations.extend(itertools.combinations(trainerID, n))
    return combinations

if __name__ == "__main__":
    T = tvec.construct()
    trainers = pd.read_csv("league_trainers.csv", sep=';')

    # trainers_default without rand and stat trainers
    trainers_default = trainers[trainers['trainerID'] < get_limes_id(trainers)]
    trainers_rand_stat = trainers[trainers['trainerID'] > get_limes_id(trainers)-1]

    league_size = [8, 18, 28, 38] #20

    for size in league_size:
        trainers_selected = trainers_default.sample(n=size)
        trainers_selected = trainers_selected.append(trainers_rand_stat, ignore_index=False)
        trainerID = trainers_selected['trainerID'].unique()
        combinations = construct_combinations(trainerID)
        for i, trainer in enumerate(combinations):
            #print('duel', i)
            trainers_selected = duel(trainer[0], trainer[1], trainers_selected, T)

        path = 'league_result_'+str(size+2)+'.csv'
        trainers_selected = trainers_selected.sort_values(by=['wins'])
        trainers_selected.to_csv(path, sep=';', index=False)
        print(trainers_selected)
