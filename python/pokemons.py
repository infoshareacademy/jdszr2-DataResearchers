import pandas as pd
import numpy as np
import dbloader

# ------------------------------------------------------------------------------
# HOW TO USE:
# 1. run pokemons.py to construct 'league_pokemons.csv' <- expensive calculations
# 2. run trainers.py to construct 'league_trainers.csv'
# 3. run league.py to construct 'league_results.csv'
# ------------------------------------------------------------------------------

def get_sample(pokemon_df):
    return pokemon_df.loc[ (pokemon_df['pokelevel'] > 48) & (pokemon_df['pokelevel'] < 52)]

def construct_pokemons(pokemon_df, trainers_cp_df):
    pokesimulation_df = pokemon_df.loc[ (pokemon_df['pokelevel'] > 46) & (pokemon_df['pokelevel'] < 54)]
    selected_trainers_len = len(pokesimulation_df.trainerID.unique() )
    all_trainers_len = len(trainers_cp_df)
    part_of_all = selected_trainers_len / all_trainers_len

    print(f'{selected_trainers_len} trainers with pokemons at level between 46 and 54 is {int(part_of_all*100)}% from {all_trainers_len} all trainers')

    # make sure you get all pokemons in the backpack of selected trainers
    league = pd.DataFrame()
    for trainerID in pokesimulation_df.trainerID.unique():
        print(trainerID, type(trainerID))
        for index, row in pokesimulation_df.iterrows():
            print(row['trainerID'], type(row['trainerID']), type(trainerID))
            if np.int64(row['trainerID']) == trainerID:
                print('create df')
                for index2, row2 in trainers_cp_df.iterrows():
                    if row['trainerID'] == row2['trainerID']:
                        data = {
                            'trainerID': row['trainerID'],
                            'place': row['place'],
                            'pokename': row['pokename'],
                            'pokelevel': row['pokelevel'],
                            'type1': row['type1'],
                            'type2': row['type2'],
                            'hp': row['hp'],
                            'maxhp': row['maxhp'],
                            'defense': row['defense'],
                            'spatk': row['spatk'],
                            'speed': row['speed'],
                            'Combat Power': row['Combat Power'],
                            'pokemonID': row['pokemonID'],
                            'trainername': row2['trainername'],
                            'Combat Power Sum': row2['Combat Power Sum']
                        }
                        df = pd.DataFrame(data, columns=['trainerID','place','pokename', 'pokelevel', 'type1', 'type2', 'hp', 'maxhp', 'defense', 'spatk', 'speed', 'Combat Power', 'pokemonID', 'trainername', 'Combat Power Sum'], index=[0])

                        league  = pd.concat([league, df]).reset_index(drop=True)
                        print(df)
    league.to_csv('league_pokemons.csv', index=False)


if __name__ == "__main__":
    print('read() tests:')
    pokemon_df, trainers_df, trainers_cp_df = dbloader.read()
    print(pokemon_df.head())
    print(trainers_df.head())
    print(trainers_cp_df.head())
    construct_pokemons(pokemon_df, trainers_cp_df)
