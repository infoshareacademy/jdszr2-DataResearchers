import fight
import tvec
import random
import numpy as np
import pandas as pd

def import_league(path):
    return pd.read_csv(path, sep=';')

def select_trainers(df):
    pass

# RUN AS __main__ TO PERFORM MODULE TESTS
if __name__ == "__main__":
    df = import_league("league_test.csv")
    select_trainers(df)
