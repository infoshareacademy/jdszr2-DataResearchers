# **Project : Does demography determine who people vote for?**
*Overview of general demographic statistics, interesting cases and anomalies*

Kaggle link:
https://www.kaggle.com/benhamner/2016-us-election#county_facts_dictionary.csv

<img src="https://i.ibb.co/pj0Pn6X/mapka.png" width="80%">

##  **Table of contents**
1. [Methodology](#methodology)
2. [Variables](#variables)
<<<<<<< HEAD
   1. [Home-ownership rate](#Home-ownership-rate)
   2. [Veterans factor](#Veterans-factor)
   3. [White alone](#White-alone)
   4. [Methodology](#methodology)
=======
>>>>>>> 7f907aacfee34e3793e78b28b431922486132efb


## **Methodology**

<img src="https://i.ibb.co/RTTTDNM/metodology.png" width="80%">

<<<<<<< HEAD
### **Technology**
In this project we mainly used:
* PostgreSQL 13.1
* Python 3.8.3 and libraries:
  * matplotlib.pyplot
  * pandas
  * seaborn
* Tableau
=======
### **How?**
To answer the main question we needed to obtain data from kaggle.
We uploaded data to PostgreSQL and started working on it.
>>>>>>> 7f907aacfee34e3793e78b28b431922486132efb

### **Data**
Our database consisted 3 tables:
* primary_results (*primary results of the preelection phase in every county*)
* county_facts (*information about counties*)
* county_facts_dictionary (*described variables from county_facts table*)

<<<<<<< HEAD
### **Let's get it started**
After creating database in PostgreSQL we started to dig into given data. We found out that not every county in primary_results table has it's equivalent in county_facts table. In short, there was lack of data about some counties.
| primary_results | county_facts| difference  |
| ------------- |:-------------:| -----:|
| 4207      | 3195 | 1012 |

In order to answer given question, we needed to drop those counties which are not fully described.

=======
>>>>>>> 7f907aacfee34e3793e78b28b431922486132efb
##  **Variables**
We have chosen 7 main variables:
* Home-ownership rate (*HSG445213*)
* Veterans factor (*based on VET605213 and PST045214*)
* White alone (*RHI125214*)
* Black or African American alone (*RHI225214*)
* Per capita money income in past 12 months (*INC910213*)
* Persons 65 years and over (*AGE775214*)
* Population per square mile (*POP060210*)

<<<<<<< HEAD
### **Home-ownership rate**


<img src="https://i.ibb.co/h1vWGSZ/Screenshot-from-2020-11-17-20-11-14.jpg" width="%">

#### *Description*

party     |avg              |q1  |median|q3  |std              |
----------|-----------------|----|------|----|-----------------|
Democrat  |69.01|64.4|  71.8|75.6|9.41|
Republican|73.74|69.9|  76.1|78.1|6.41|

#### *Information Value*


lp|home_ownership_range|counties|democrats|republicans|d_democrats           |d_republicans         |woe                    |diff(d_democrats, d_republicans)|contributor                               |iv                                        |
----|--------------------|--------|---------|-----------|----------------------|----------------------|-----------------------|--------------------------------|------------------------------------------|------------------------------------------|
 0|<69                 |     589|      395|        194|0.42|0.21|-0.71|         -0.21|0.15|0.26|
 1|from 69 to 75       |     578|      280|        298|0.3|0.32| 0.06|          0.02|0.001|0.26|
 2|from 75 to 79       |     429|      161|        268|0.17|0.29| 0.51|          0.11|0.09|0.26|
 3|from 79 to 100      |     282|      103|        179|0.11|0.2| 0.55|          0.08|0.045|0.26|

 ### **Veterans factor**

 
 <img src="https://i.ibb.co/gmZBCVm/veterans.png" width="50%">

#### *Description*

 party     |avg |q1  |median|q3  |std |
----------|----|----|------|----|----|
Democrat  |0.07|0.06|  0.07|0.09|0.02|
Republican|0.08|0.07|  0.08|0.10|0.02|

#### *Information Value*

lp|veterans_range   |counties|democrats|republicans|d_democrats           |d_republicans         |woe                    |diff(d_democrats, d_republicans)|contributor                               |iv                                        |
----|-----------------|--------|---------|-----------|----------------------|----------------------|-----------------------|--------------------------------|------------------------------------------|------------------------------------------|
0|<0.06            |     453|      306|        147|0.33|0.164|-0.73|         -0.17|0.12|0.23|
1|from 0.06 to 0.08|     743|      369|        374|0.39|0.4| 0.01|          0.01|0.0001|0.23|
2|from 0.08 to 0.1 |     454|      196|        258|0.21|0.27| 0.27|          0.07|0.02|0.23|
3|from 0.1 to 1    |     228|       68|        160|0.07|0.17| 0.86|          0.1|0.08|0.23|

 ### White alone

 
 <img src="https://i.ibb.co/zQK6qZg/white-alone.png" width="50%">
<<<<<<< HEAD

 #### *Description*
=======
>>>>>>> 7f907aacfee34e3793e78b28b431922486132efb
=======
>>>>>>> fa58a47d3bd6c3ae850b3344170443bb91d29152

 #### *Description*
