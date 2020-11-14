import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt


path = "/Users/michal/infoshare/projekt_zespolowy_sql/jdszr2-DataResearchers/sql/csv/races.csv"
df = pd.read_csv(path, sep=';')



fig = sns.distplot(a=df[df['party']=='Democrat']["indians"],
                   hist=True, bins=25, kde=False, color="blue",
                   label='Democrats')
fig = sns.distplot(a=df[df['party']=='Republican']["indians"],
                   hist=True, bins=25, kde=False, color="red",
                   label='Republicans')

#df["income"].describe().to_csv("/Users/michal/infoshare/projekt_zespolowy_sql/jdszr2-DataResearchers/sql/csv/income_per_capita_stats.csv",
#    sep=';', header=True)
fig.legend()
fig.set(title='');
fig.set(ylabel='Counties', xlabel='Income per capita')
plt.show()
