# **Project : Does demography determine who people vote for?**
*Overview of general demographic statistics, interesting cases and anomalies*

Kaggle link:
https://www.kaggle.com/benhamner/2016-us-election#county_facts_dictionary.csv

<img src="https://i.ibb.co/pj0Pn6X/mapka.png" width="80%">

##  **Table of contents**
1. [Methodology](#methodology)
2. [Variables](#variables)

   1. [Home-ownership rate](#Home-ownership-rate)
   2. [Veterans factor](#Veterans-factor)
   3. [White alone](#White-alone)
   4. [Per capita money income in past 12 months](#Per-capita-money-income-in-past-12-months)
   5. [Persons 65 years and over](#Persons-65-years-and-over)
3. [Conclusion](#conclusion)




## **Methodology**

<img src="https://i.ibb.co/RTTTDNM/metodology.png" width="80%">


### **Technology**
In this project we mainly used:
* PostgreSQL 13.1
* Python 3.8.3 and libraries:
  * matplotlib.pyplot
  * pandas
  * seaborn
* Tableau

### **How?**
To answer the main question we needed to obtain data from kaggle.
We uploaded data to PostgreSQL and started working on it.


### **Data**
Our database consisted 3 tables:
* primary_results (*primary results of the preelection phase in every county*)
* county_facts (*information about counties*)
* county_facts_dictionary (*described variables from county_facts table*)


### **Let's get it started**
After creating database in PostgreSQL we started to dig into given data. We found out that not every county in primary_results table has it's equivalent in county_facts table. In short, there was lack of data about some counties.
| primary_results | county_facts| difference  |
| ------------- |:-------------:| -----:|
| 4207      | 3195 | 1012 |

In order to answer given question, we needed to drop those counties which are not fully described.

=======

##  **Variables**
We have chosen 5 main variables:
* Home-ownership rate (*HSG445213*)
* Veterans factor (*based on VET605213 and PST045214*)
* White alone (*RHI125214*)
* Per capita money income in past 12 months (*INC910213*)
* Persons 65 years and over (*AGE775214*)


### **Home-ownership rate**


<img src="https://i.ibb.co/h1vWGSZ/Screenshot-from-2020-11-17-20-11-14.jpg" width="%">

#### ***Description***

party     |avg              |q1  |median|q3  |std              |
----------|-----------------|----|------|----|-----------------|
Democrat  |69.01|64.4|  71.8|75.6|9.41|
Republican|73.74|69.9|  76.1|78.1|6.41|

#### ***Information Value***


lp|home_ownership_range|counties|democrats|republicans|d_democrats           |d_republicans         |woe                    |diff(d_democrats, d_republicans)|contributor                               |iv                                        |
----|--------------------|--------|---------|-----------|----------------------|----------------------|-----------------------|--------------------------------|------------------------------------------|------------------------------------------|
 0|<69                 |     589|      395|        194|0.42|0.21|-0.71|         -0.21|0.15|0.26|
 1|from 69 to 75       |     578|      280|        298|0.3|0.32| 0.06|          0.02|0.001|0.26|
 2|from 75 to 79       |     429|      161|        268|0.17|0.29| 0.51|          0.11|0.09|0.26|
 3|from 79 to 100      |     282|      103|        179|0.11|0.2| 0.55|          0.08|0.045|0.26|

 ### **Veterans factor**

 
 <img src="https://i.ibb.co/gmZBCVm/veterans.png" width="50%">

#### ***Description***

 party     |avg |q1  |median|q3  |std |
----------|----|----|------|----|----|
Democrat  |0.07|0.06|  0.07|0.09|0.02|
Republican|0.08|0.07|  0.08|0.10|0.02|

#### ***Information Value***

lp|veterans_range   |counties|democrats|republicans|d_democrats           |d_republicans         |woe                    |diff(d_democrats, d_republicans)|contributor                               |iv                                        |
----|-----------------|--------|---------|-----------|----------------------|----------------------|-----------------------|--------------------------------|------------------------------------------|------------------------------------------|
0|<0.06            |     453|      306|        147|0.33|0.164|-0.73|         -0.17|0.12|0.23|
1|from 0.06 to 0.08|     743|      369|        374|0.39|0.4| 0.01|          0.01|0.0001|0.23|
2|from 0.08 to 0.1 |     454|      196|        258|0.21|0.27| 0.27|          0.07|0.02|0.23|
3|from 0.1 to 1    |     228|       68|        160|0.07|0.17| 0.86|          0.1|0.08|0.23|

 ### **White alone**

 
 <img src="https://i.ibb.co/zQK6qZg/white-alone.png" width="50%">

 #### ***Description***

 party     |white avg        |white std         |black avg         |black std         |others avg        |others std        |
-------------|-----------------|------------------|------------------|------------------|------------------|------------------|
Democrat  |65.46| 23.95|17.61|20.84|16.13|20.59|
Republican|81.94|14.75| 6.12| 8.68| 11.12|13.06|

#### ***Information Value***

lp|races_range             |counties|democrats|republicans|d_democrats           |d_republicans         |woe                    |diff(d_democrats, d_republicans)|contributor                               |iv                                        |
--|------------------------|--------|---------|-----------|----------------------|----------------------|-----------------------|--------------------------------|------------------------------------------|------------------------------------------|
0|white > 75%             |     929|      338|        591|0.36|0.63| 0.56|          0.27|0.15|0.47|
1|white between 65 and 75%|     254|      102|        152|0.11|0.16| 0.4|          0.05|0.02|0.47|
2|white < 64              |     695|      499|        196|0.53|0.21|-0.94|         -0.32|0.30|0.47|

### **Per capita money income in past 12 months**

<img src="https://i.ibb.co/3CNDbnv/income.png" width="50%">

#### ***Description***

party     |avg               |q1   |median|q3   |std              |
-------------|------------------|-----|------|-----|-----------------|
Democrat  |23291.84|18750| 22381|26271|6854.32|
Republican|23108.78|20052| 22551|25378|4573.07|

#### ***Information Value***

lp|income_range       |counties|democrats|republicans|d_democrats           |d_republicans         |woe                    |diff(d_democrats, d_republicans)|contributor                               |iv                                        |
--|-------------------|--------|---------|-----------|----------------------|----------------------|-----------------------|--------------------------------|------------------------------------------|------------------------------------------|
 0|<17000             |     168|      125|         43|0.13|0.05|-1.07|         -0.09|0.09|0.18|
 1|from 17000 to 19999|     396|      207|        189|0.22|0.20|-0.09|         -0.02|0.002|0.18|
 2|from 20000 to 24999|     743|      299|        444|0.32|0.47| 0.4|          0.15|0.06|0.18|
 3|from 25000 to 29999|     388|      194|        194|0.21|0.21| 0|          0|0|0.18|
 4|>= 30000           |     183|      114|         69|0.12|0.07|-0.50|         -0.05|0.02|0.18|

 ### **Persons 65 years and over**

<img src="https://i.ibb.co/dGfNNpF/Screenshot-from-2020-11-18-18-43-05.jpg" width="50%">

 #### ***Description***

 party     |avg               |q1  |median|q3  |std               |
----------|------------------|----|------|----|------------------|
Democrat  |16.28|13.6|  18.3|18.6|3.88|
Republican| 18.20|15.4|  17.6|20.4| 4.46|

#### ***Information Value***

lp|above_65_range|counties|democrats|republicans|d_democrats           |d_republicans         |woe                    |diff(d_democrats, d_republicans)|contributor                               |iv                                        |
----|--------------|--------|---------|-----------|----------------------|----------------------|-----------------------|--------------------------------|------------------------------------------|------------------------------------------|
0|<69           |     406|      269|        137|0.29|0.15|-0.67|         -0.14|0.09|0.16|
1|from 69 to 75 |     768|      380|        388|0.40|0.41| 0.02|          0.009|0.0002|0.16|
2|from 75 to 79 |     341|      161|        180|0.17|0.19| 0.11|          0.02|0.002|0.16|
3|from 79 to 100|     363|      129|        234|0.14|0.25| 0.6|          0.11|0.07|0.16|

 
## **Conclusion**
To be honest in most of the picked variables the information value is marked as moderate predictive power index (iv is between 0.1 - 0.3).
It answers our main question perfectly.
So does demography determine who people vote for? In short, yes. Demography can determine who counties vote for.
