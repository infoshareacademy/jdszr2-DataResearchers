import numpy as np
import pandas as pd


def construct():
    df = pd.read_csv("Type matrix.csv", sep=',')
    tvec = dict()
    for index, row in df.iterrows():
        for col in df.columns:
            if col != 'type':
                key = str(row['type'])+','+col
                tvec[key] = np.single(row[col])
    return tvec

def show(tvec):
    for key, item in tvec.items():
        print(key, item)

def modifier(pok1_typeX, pok2_typeX, tvec):
    key = pok1_typeX+','+pok2_typeX
    default = 1.0
    return tvec.get(key, default)


# RUN AS __main__ TO PERFORM MODULE TESTS
if __name__ == "__main__":
    print('construct test:')
    tvec = construct()
    print(type(tvec))

    print('\show(tvec) test:')
    show(tvec)

    print('\nmodifier(type1, type2, tvec) test:')
    print('Normal,Normal', modifier('Normal', 'Normal', tvec))
    print('Normal,Flying', modifier('Normal', 'Flying', tvec))
    print('Fairy,Dark', modifier('Fairy', 'Dark', tvec))
    print('Dark,None', modifier('Dark', 'None', tvec))
    print('None,Dark', modifier('Normal', 'Dark', tvec))
    print('None,None', modifier('None', 'None', tvec))
