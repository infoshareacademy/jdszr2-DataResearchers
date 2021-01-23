import numpy as np
import pandas as pd
import random
import sys

# ------------------------------------------------------------------------------
# HOW TO USE:
# 1. run pokemons.py to construct 'league_pokemons.csv' <- expensive calculations
# 2. run trainers.py to construct 'league_trainers.csv'
# 3. run league.py to construct 'league_results.csv'
# ------------------------------------------------------------------------------

def get_place_and_list(list):
    place = random.choice(list)
    list.remove(place)
    return place, list

def prep_random(league_6poks):
    random_trainer = league_6poks.sample(n=6)
    last_element = league_6poks.iloc[-1]
    place_list = [0, 1, 2, 3, 4, 5]
    random_pokemonID = last_element['pokemonID']+1
    for index, row in random_trainer.iterrows():
        # const:
        random_trainer.loc[index, 'trainerID'] = last_element['trainerID']+1
        random_trainer.loc[index, 'trainername'] = 'random_trainer'
        random_trainer.loc[index, 'Combat Power Sum'] = random_trainer['Combat Power'].sum()
        # var:
        place, place_list = get_place_and_list(place_list)
        random_trainer.loc[index, 'place'] = place
        random_trainer.loc[index, 'pokemonID'] = random_pokemonID
        random_pokemonID+=1
    return random_trainer


def get_pokemon(type1, type2, df):
    type1_is = df['type1']==type1
    set1 = df[type1_is]
    type2_is = set1['type2']==type2
    set12 = set1[type2_is]
    return set12.sample(n=1)

def prep_stat(league_6poks):
    pok1 = get_pokemon('Dragon', 'Electric', league_6poks)
    pok2 = get_pokemon('Dragon', 'Fire', league_6poks)
    pok3 = get_pokemon('Normal', 'None', league_6poks)
    pok4 = get_pokemon('Electric', 'Flying', league_6poks)
    pok5 = get_pokemon('Fire', 'Flying', league_6poks)
    pok6 = get_pokemon('Ground', 'None', league_6poks)

    stat_trainer = pok1.append(pok2, ignore_index = True)
    stat_trainer = stat_trainer.append(pok3, ignore_index = True)
    stat_trainer = stat_trainer.append(pok4, ignore_index = True)
    stat_trainer = stat_trainer.append(pok5, ignore_index = True)
    stat_trainer = stat_trainer.append(pok6, ignore_index = True)

    last_element = league_6poks.iloc[-1]
    pokemonID = last_element['pokemonID']+1
    place_list = [0, 1, 2, 3, 4, 5]
    for index, row in stat_trainer.iterrows():
        # const:
        stat_trainer.loc[index, 'trainerID'] = last_element['trainerID']+1
        stat_trainer.loc[index, 'trainername'] = 'stat_trainer'
        stat_trainer.loc[index, 'Combat Power Sum'] = stat_trainer['Combat Power'].sum()
        # var:
        place, place_list = get_place_and_list(place_list)
        stat_trainer.loc[index, 'place'] = place
        stat_trainer.loc[index, 'pokemonID'] = pokemonID
        pokemonID+=1
    stat_trainer = stat_trainer.sort_values(by=['place'])
    return stat_trainer


def construct_trainers(trainerID):
    league_trainers = pd.DataFrame(trainerID, columns=['trainerID'])
    league_trainers['trainername']=np.nan
    league_trainers['wins'] = 0
    league_trainers['Combat Power Sum'] = 0
    league_trainers['pok0_id']=np.nan
    league_trainers['pok0_type1']=np.nan
    league_trainers['pok0_type2']=np.nan
    league_trainers['pok0_cp']=np.nan
    league_trainers['pok0_modcp']=np.nan
    league_trainers['pok0_speed']=np.nan
    league_trainers['pok0_isaccess']=True
    league_trainers['pok1_id']=np.nan
    league_trainers['pok1_type1']=np.nan
    league_trainers['pok1_type2']=np.nan
    league_trainers['pok1_cp']=np.nan
    league_trainers['pok1_modcp']=np.nan
    league_trainers['pok1_speed']=np.nan
    league_trainers['pok1_isaccess']=True
    league_trainers['pok2_id']=np.nan
    league_trainers['pok2_type1']=np.nan
    league_trainers['pok2_type2']=np.nan
    league_trainers['pok2_cp']=np.nan
    league_trainers['pok2_modcp']=np.nan
    league_trainers['pok2_speed']=np.nan
    league_trainers['pok2_isaccess']=True
    league_trainers['pok3_id']=np.nan
    league_trainers['pok3_type1']=np.nan
    league_trainers['pok3_type2']=np.nan
    league_trainers['pok3_cp']=np.nan
    league_trainers['pok3_modcp']=np.nan
    league_trainers['pok3_speed']=np.nan
    league_trainers['pok3_isaccess']=True
    league_trainers['pok4_id']=np.nan
    league_trainers['pok4_type1']=np.nan
    league_trainers['pok4_type2']=np.nan
    league_trainers['pok4_cp']=np.nan
    league_trainers['pok4_modcp']=np.nan
    league_trainers['pok4_speed']=np.nan
    league_trainers['pok4_isaccess']=True
    league_trainers['pok5_id']=np.nan
    league_trainers['pok5_type1']=np.nan
    league_trainers['pok5_type2']=np.nan
    league_trainers['pok5_cp']=np.nan
    league_trainers['pok5_modcp']=np.nan
    league_trainers['pok5_speed']=np.nan
    league_trainers['pok5_isaccess']=True
    return league_trainers

def fill_trainers(id, pdf, tdf):
    for i in range(0,6):
        trainer_is = pdf['trainerID']==id
        get_pdf = pdf[trainer_is]
        pok = get_pdf['place']==i
        get_pdf_pok = get_pdf[pok]

        trainer_is = tdf['trainerID']==id
        get_tdf = tdf[trainer_is]

        index = tdf.index
        condition = tdf["trainerID"] == id
        trainer_index = index[condition]
        trainer_index_list = trainer_index.tolist()
        #print('trainer_index_list', trainer_index_list)
        index_tdf = trainer_index_list[0]

        index = pdf.index
        condition = pdf["trainerID"] == id
        trainer_with_poks_index = index[condition]
        trainer_index_list = trainer_with_poks_index.tolist()
        #print('trainer_index_list', trainer_index_list)
        index_pdf_0 = trainer_index_list[0]
        index_pdf_1 = trainer_index_list[1]
        index_pdf_2 = trainer_index_list[2]
        index_pdf_3 = trainer_index_list[3]
        index_pdf_4 = trainer_index_list[4]
        index_pdf_5 = trainer_index_list[5]

        tdf.loc[index_tdf, 'trainername'] = pdf.loc[index_pdf_0, 'trainername']
        tdf.loc[index_tdf, 'Combat Power Sum'] = pdf.loc[index_pdf_0, 'Combat Power Sum']

        ## pok0
        tdf.loc[index_tdf, 'pok0_id'] = pdf.loc[index_pdf_0, 'pokemonID']
        tdf.loc[index_tdf, 'pok0_type1'] = pdf.loc[index_pdf_0, 'type1']
        tdf.loc[index_tdf, 'pok0_type2'] = pdf.loc[index_pdf_0, 'type2']
        tdf.loc[index_tdf, 'pok0_cp'] = pdf.loc[index_pdf_0, 'Combat Power']
        tdf.loc[index_tdf, 'pok0_modcp'] = pdf.loc[index_pdf_0, 'Combat Power']
        tdf.loc[index_tdf, 'pok0_speed'] = pdf.loc[index_pdf_0, 'speed']

        ## pok1
        tdf.loc[index_tdf, 'pok1_id'] = pdf.loc[index_pdf_1, 'pokemonID']
        tdf.loc[index_tdf, 'pok1_type1'] = pdf.loc[index_pdf_1, 'type1']
        tdf.loc[index_tdf, 'pok1_type2'] = pdf.loc[index_pdf_1, 'type2']
        tdf.loc[index_tdf, 'pok1_cp'] = pdf.loc[index_pdf_1, 'Combat Power']
        tdf.loc[index_tdf, 'pok1_modcp'] = pdf.loc[index_pdf_1, 'Combat Power']
        tdf.loc[index_tdf, 'pok1_speed'] = pdf.loc[index_pdf_1, 'speed']

        ## pok2
        tdf.loc[index_tdf, 'pok2_id'] = pdf.loc[index_pdf_2, 'pokemonID']
        tdf.loc[index_tdf, 'pok2_type1'] = pdf.loc[index_pdf_2, 'type2']
        tdf.loc[index_tdf, 'pok2_type2'] = pdf.loc[index_pdf_2, 'type2']
        tdf.loc[index_tdf, 'pok2_cp'] = pdf.loc[index_pdf_2, 'Combat Power']
        tdf.loc[index_tdf, 'pok2_modcp'] = pdf.loc[index_pdf_2, 'Combat Power']
        tdf.loc[index_tdf, 'pok2_speed'] = pdf.loc[index_pdf_2, 'speed']

        ## pok3
        tdf.loc[index_tdf, 'pok3_id'] = pdf.loc[index_pdf_3, 'pokemonID']
        tdf.loc[index_tdf, 'pok3_type1'] = pdf.loc[index_pdf_3, 'type1']
        tdf.loc[index_tdf, 'pok3_type2'] = pdf.loc[index_pdf_3, 'type2']
        tdf.loc[index_tdf, 'pok3_cp'] = pdf.loc[index_pdf_3, 'Combat Power']
        tdf.loc[index_tdf, 'pok3_modcp'] = pdf.loc[index_pdf_3, 'Combat Power']
        tdf.loc[index_tdf, 'pok3_speed'] = pdf.loc[index_pdf_3, 'speed']

        ## pok4
        tdf.loc[index_tdf, 'pok4_id'] = pdf.loc[index_pdf_4, 'pokemonID']
        tdf.loc[index_tdf, 'pok4_type1'] = pdf.loc[index_pdf_4, 'type1']
        tdf.loc[index_tdf, 'pok4_type2'] = pdf.loc[index_pdf_4, 'type2']
        tdf.loc[index_tdf, 'pok4_cp'] = pdf.loc[index_pdf_4, 'Combat Power']
        tdf.loc[index_tdf, 'pok4_modcp'] = pdf.loc[index_pdf_4, 'Combat Power']
        tdf.loc[index_tdf, 'pok4_speed'] = pdf.loc[index_pdf_4, 'speed']

        ## pok5
        tdf.loc[index_tdf, 'pok5_id'] = pdf.loc[index_pdf_5, 'pokemonID']
        tdf.loc[index_tdf, 'pok5_type1'] = pdf.loc[index_pdf_5, 'type1']
        tdf.loc[index_tdf, 'pok5_type2'] = pdf.loc[index_pdf_5, 'type2']
        tdf.loc[index_tdf, 'pok5_cp'] = pdf.loc[index_pdf_5, 'Combat Power']
        tdf.loc[index_tdf, 'pok5_modcp'] = pdf.loc[index_pdf_5, 'Combat Power']
        tdf.loc[index_tdf, 'pok5_speed'] = pdf.loc[index_pdf_5, 'speed']
    return tdf


if __name__ == "__main__":
    league_df = pd.read_csv('league_pokemons.csv')
    league_6poks = league_df[league_df['trainerID'].map(league_df['trainerID'].value_counts()) == 6]
    random_trainer= prep_random(league_6poks)
    league_6poks=league_6poks.append(random_trainer, ignore_index = True)
    stat_trainer = prep_stat(league_6poks)
    league_6poks=league_6poks.append(stat_trainer, ignore_index = True)
    trainerID = league_6poks['trainerID'].unique()
    league_trainers = construct_trainers(trainerID)
    for i,trainer_id in enumerate(trainerID):
        print(i, trainer_id)
        league_trainers=fill_trainers(trainer_id,league_6poks,league_trainers)

    print(league_trainers.tail())
    league_trainers.to_csv('league_trainers.csv', sep=';',index=False)
