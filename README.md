# econ-extension

The original data set available in this repository is taken from 

"Attack When the World Is Not Watching?
U.S. News and the Israeli-Palestinian Conflict" 
by
Ruben Durante
Universitat Pompeu Fabra, Barcelona GSE, Sciences Po, and CEPR

and 
Ekaterina Zhuravskaya
Paris School of Economics (EHESS), and CEPR

The original files are available in Ekaterina Zhuravskaya's dropbox available on her personal page, can be accessed in through following link : 

https://www.dropbox.com/s/r6y3zce2ocp6if2/replication.zip?dl=0&file_subpath=%2Freplication

Extension 1 : Pakistan and US drones attacks
  1. We imported data for US drone attacks in Pakistan, and stored them in "data_drone.xlsx".
  2. We merged the author's data frame "datafile.csv" and "data_drone.xlsx" using Jupyter notebooks, using the following file : "pakistan_drones_extension.ipynb"
  3. The resulted merged data frame is "data_new_tables.dta"
  4. We ran "data_new_tables.dta" in Stata, with the file : "stata_extension_pakistan_drones.do"

Extension 2 : Hijri calendar fixed effects
  1. Using Jupyter notebooks, we converted the original dataset "datafile.csv" months into Hijri months.
  2. We obtained the following data set "hijri_df.dta"
  3. We ran the regressions in Stata using "hijri_df.dta" in the following file --> "stata_extension_hijri_FE.do"
  
  Extension 3 : Twitter data
    1. Using Jupyter notebooks, we ran the "tweet.ipynb" file and stored the result in "tweet.csv".
    2. We merged the author's data frame "datafile.csv" and "tweet.csv" using Jupyter notebooks, using the following file : twitter_merge.ipynb"
    3. The resulted merged data frame is "data_tweet_new.dta"
    4. We ran "data_tweet_new.dta" in Stata, with the file : "stata_extension_tweet.do"
