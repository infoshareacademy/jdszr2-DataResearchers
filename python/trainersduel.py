import fight
import tvec
import random
import dbloader
import numpy as np
import pandas as pd


# RUN AS __main__ TO PERFORM MODULE TESTS
if __name__ == "__main__":
    pokemon_df, trainers_df, trainers_cp_df = dbloader.read()
    print('dbloader.read() tests:', type(pokemon_df), type(trainers_df), type(trainers_cp_df))

    print(trainers_cp_df)
