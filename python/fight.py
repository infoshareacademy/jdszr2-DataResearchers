import tvec
import random
import dbloader
import numpy as np
import pandas as pd

def start(pok1_id, pok1_type1, pok1_type2, pok1_CP, pok1_speed, pok2_id, pok2_type1, pok2_type2, pok2_CP, pok2_speed, T):
    max_CP = 10000

    # CP updater
    mod1 = tvec.modifier(pok1_type1, pok2_type1, T)
    mod2 = tvec.modifier(pok1_type2, pok2_type1, T)
    mod3 = tvec.modifier(pok1_type1, pok2_type2, T)
    mod4 = tvec.modifier(pok1_type2, pok2_type2, T)
    pok1_CP *= mod1 * mod2 * mod3 * mod4
    pok2_CP *= mod1 * mod2 * mod3 * mod4
    if pok1_CP > max_CP:
        pok1_CP = max_CP
    if pok2_CP > max_CP:
        pok2_CP = max_CP

    # winning rules
    winner = None

    if pok1_CP > pok2_CP:
        winner = pok1_id
    else:
        winner = pok2_id

    # draw elimination
    if pok1_CP == pok2_CP:
        if pok1_speed > pok2_speed:
            winner = pok1_id
        elif pok1_speed < pok2_speed:
            winner = pok2_id
        else:
            winner = random.choice([pok1_id, pok2_id])

    return winner


# RUN AS __main__ TO PERFORM MODULE TESTS
if __name__ == "__main__":
    pokemon_df, trainers_df, trainers_cp_df = dbloader.read()
    print('dbloader.read() tests:', type(pokemon_df), type(trainers_df), type(trainers_cp_df))

    T = tvec.construct()
    print('tvec.construct() tests:', type(T))

    print('tvec.show(T) tests:')
    tvec.show(T)

    print('tvec.modifier(Normal, None, T) tests:', tvec.modifier('Normal', 'None', T))
    print('tvec.modifier(Normal, Normal, T) tests:', tvec.modifier('Normal', 'Normal', T))
    print('tvec.modifier(Water, Fire, T) tests:', tvec.modifier('Water', 'Fire', T))

    pokemon2_df = pokemon_df.head()

    print('fight() tests:')
    for index1, pok1 in pokemon2_df.iterrows():
        for index2, pok2 in pokemon2_df.iterrows():
            pok1_id = pok1['pokemonID']
            pok1_type1 = pok1['type1']
            pok1_type2 = pok1['type2']
            pok1_CP = pok1['Combat Power']
            pok1_speed = pok1['speed']

            pok2_id = pok2['pokemonID']
            pok2_type1 = pok2['type1']
            pok2_type2 = pok2['type2']
            pok2_CP = pok2['Combat Power']
            pok2_speed = pok2['speed']

            winner = start(pok1_id, pok1_type1, pok1_type2, pok1_CP, pok1_speed,
                pok2_id, pok2_type1, pok2_type2, pok2_CP, pok2_speed, T)

            print(pok1_id, pok1_type1, pok1_type2, pok1_CP, pok1_speed,
                pok2_id, pok2_type1, pok2_type2, pok2_CP, pok2_speed, type(T), winner)
