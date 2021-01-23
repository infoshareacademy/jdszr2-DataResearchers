import pandas as pd
import sqlite3
import numpy as np

# ------------------------------------------------------------------------------
# encapsulation of db loading
# ------------------------------------------------------------------------------

def add_combat_power(pokemon_df):
    pokemon_df["Combat Power"] = (pokemon_df["hp"]+pokemon_df["attack"]+pokemon_df["defense"]+pokemon_df["spatk"]+pokemon_df["spdef"]+pokemon_df["speed"])*pokemon_df["pokelevel"]*6/100

def add_pokemon_id(pokemon_df):
    pokemon_df['pokemonID'] = list(range(len(pokemon_df.index)))

def read():
    # Read sqlite query results into a pandas DataFrame
    con = sqlite3.connect("database.sqlite")
    pokemon_df = pd.read_sql_query("SELECT * from Pokemon", con)
    trainers_df = pd.read_sql_query("SELECT * from Trainers", con)
    trainers_cp_df = pd.read_sql_query("SELECT t.*,sum((p.hp+p.attack+p.defense+p.spatk+p.spdef+p.speed)*p.pokelevel *6/100) as 'Combat Power Sum' from Trainers t join Pokemon p on t.trainerID = p.trainerID group by t.trainerID", con)
    # Verify that result of SQL query is stored in the dataframe
    con.close()

    # Add new columns into a pokemon DataFrame
    add_combat_power(pokemon_df)
    add_pokemon_id(pokemon_df)

    return pokemon_df, trainers_df, trainers_cp_df


# RUN AS __main__ TO PERFORM MODULE TESTS
if __name__ == "__main__":
    print('read() tests:')
    pokemon_df, trainers_df, trainers_cp_df = read()
    print(pokemon_df.head())
    print(trainers_df.head())
    print(trainers_cp_df.head())
