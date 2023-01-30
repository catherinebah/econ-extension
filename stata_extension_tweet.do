************************************************************************************************************
set more off


* Define main directory
global main="/Users/elliott/Documents/Swiss/2022 autumn/Economics for challenging times/final/replication/"

* Define data directory
global dta="$main/dta/"

* Define tables directory
global tables="$main/tables/"

************************************************************************
** Table 2. Coverage of Conflict, News Pressure, and Google Searches
************************************************************************

use "$dta/data_tweet_new.dta", clear

gen date2 = date(date,"DMY")
format date2 %d
tsset date2
sort date2

eststo: xi: reg any_conflict_news occurrence_t_y occurrence_pal_t_y i.month i.year i.dow , cluster(monthyear)
outreg2 using "$tables/table22.tex", replace ctitle("Any news on conflict") keep(occurrence_t_y occurrence_pal_t_y) nocons label bdec(3)

eststo: xi: nbreg length_conflict_news occurrence_t_y occurrence_pal_t_y i.month i.year i.dow , vce(cluster monthyear)
outreg2 using "$tables/table22.tex", append ctitle("Length of conflict news") keep(occurrence_t_y occurrence_pal_t_y) nocons label bdec(3)

eststo: xi: reg any_conflict_news lnvic_t_y lnvic_pal_y daily_woi i.month i.year i.dow if  (occurrence_t_y==1 | occurrence_pal_t_y ==1), cluster(monthyear)
outreg2 using "$tables/table22.tex", append ctitle("Any news on conflict") keep(lnvic_t_y lnvic_pal_y daily_woi) nocons label bdec(3)

eststo: xi: nbreg length_conflict_news lnvic_t_y lnvic_pal_y daily_woi i.month i.year i.dow if  (occurrence_t_y==1 | occurrence_pal_t_y ==1), vce(cluster monthyear)
outreg2 using "$tables/table22.tex", append ctitle("Length of conflict news") keep(lnvic_t_y lnvic_pal_y daily_woi) nocons label bdec(3)

xi: newey ln_tweet_count lnvic_t_y lnvic_pal_y monthyear i.month i.year i.dow  if length_conflict_news_t_t_1!=., lag(7) force
outreg2 using "$tables/table22.tex", append stats(coef se) keep(lnvic_t_y lnvic_pal_y) nocons label bdec(3)

xi: newey ln_tweet_count lnvic_t_y lnvic_pal_y length_conflict_news_t_t_1  monthyear i.month i.year i.dow  , lag(7) force
outreg2 using "$tables/table22.tex", append stats(coef se) keep(lnvic_t_y lnvic_pal_y length_conflict_news_t_t_1) nocons label bdec(3) sdec(3)

xi: newey conflict_searches lnvic_t_y lnvic_pal_y monthyear i.month i.year i.dow  if length_conflict_news_t_t_1!=., lag(7) force
outreg2 using "$tables/table22.tex", append stats(coef se) keep(lnvic_t_y lnvic_pal_y) nocons label bdec(3)

xi: newey conflict_searches lnvic_t_y lnvic_pal_y length_conflict_news_t_t_1  monthyear i.month i.year i.dow  , lag(7) force
outreg2 using "$tables/table22.tex", append stats(coef se) keep(lnvic_t_y lnvic_pal_y length_conflict_news_t_t_1) nocons label bdec(3) sdec(3)


* Corresponding OLS regressions estimated below to display R-squared
eststo: xi: reg ln_tweet_count lnvic_t_y lnvic_pal_y monthyear i.month i.year i.dow if length_conflict_news_t_t_1!=., vce(cluster monthyear)
eststo: xi: reg ln_tweet_count lnvic_t_y lnvic_pal_y length_conflict_news_t_t_1 monthyear i.month i.year i.dow , vce(cluster monthyear)
esttab, se pr2 r2 star(* 0.1 ** 0.05 *** 0.01)


****************************************************************************************************
** Table 7. Google Search Volume, Conflict-related News, and Timing of Attacks
****************************************************************************************************

use "$dta/data_tweet_new.dta", clear

gen date2 = date(date,"DMY")
format date2 %d
tsset date2

* Generate interaction terms between presence of conflict news at t and occurrence of Israeli attacks at t and t-1
gen conflict_news_isr_occ_t=any_conflict_news*occurrence
gen conflict_news_isr_occ_t_1=any_conflict_news*l1.occurrence
gen conflict_news_no_isr_occ_t_y=any_conflict_news*(!occurrence&!l1.occurrence)

label var conflict_news_isr_occ_t "Any conflict news x Israeli attack, same day"
label var conflict_news_isr_occ_t_1 "Any conflict news x Israeli attack, previous day"
label var conflict_news_no_isr_occ_t_y "Any conflict news x no Israeli attack, same or previous day"

* Generate interaction terms between length of conflict news at t and occurrence of Israeli attacks at t and t-1
gen l_conflict_news_isr_occ_t=length_conflict_news*occurrence
gen l_conflict_news_isr_occ_t_1=length_conflict_news*l1.occurrence
gen l_conflict_news_no_isr_occ_t_y=length_conflict_news*(!occurrence&!l1.occurrence)

label var l_conflict_news_isr_occ_t "Lenght of conflict news x Israeli attack, same day"
label var l_conflict_news_isr_occ_t_1 "Lenght of  conflict news x Israeli attack, previous day"
label var l_conflict_news_no_isr_occ_t_y "Lenght of  conflict news x no Israeli attack, same or previous day"

* Generate first lags of interaction terms
sort date2
foreach var in conflict_news_isr_occ_t conflict_news_isr_occ_t_1 conflict_news_no_isr_occ_t_y l_conflict_news_isr_occ_t l_conflict_news_isr_occ_t_1 l_conflict_news_no_isr_occ_t_y{
gen L`var'=l.`var'
}

xi: newey ln_tweet_count conflict_news_isr_occ_t conflict_news_isr_occ_t_1 conflict_news_no_isr_occ_t_y lnvic l.lnvic lnvic_pal l.lnvic_pal occurrence l.occurrence occurrence_pal l.occurrence_pal monthyear i.dow  i.month, lag(7) force
test conflict_news_isr_occ_t=conflict_news_isr_occ_t_1
scalar P_v=r(p)
outreg2 using "$tables/table_8.tex", ctitle ("Log Tweet count") replace stats(coef se) keep(conflict_news_isr_occ_t conflict_news_isr_occ_t_1) nocons label bdec(3) addtext (DOW FEs, Yes, Linear time trend, Yes) addstat("p value", P_v)

xi: newey ln_tweet_count conflict_news_isr_occ_t conflict_news_isr_occ_t_1 conflict_news_no_isr_occ_t_y Lconflict_news_isr_occ_t Lconflict_news_isr_occ_t_1 Lconflict_news_no_isr_occ_t_y lnvic l.lnvic l2.lnvic lnvic_pal l.lnvic_pal l2.lnvic_pal occurrence l.occurrence  l2.occurrence occurrence_pal l.occurrence_pal   l2.occurrence_pal i.dow monthyear i.month, lag(7) force
test conflict_news_isr_occ_t=conflict_news_isr_occ_t_1
scalar P_v=r(p)
test Lconflict_news_isr_occ_t=Lconflict_news_isr_occ_t_1
scalar P1_v=r(p)
test Lconflict_news_isr_occ_t+conflict_news_isr_occ_t=Lconflict_news_isr_occ_t_1+conflict_news_isr_occ_t_1
scalar P2_v=r(p)
outreg2 using "$tables/table_8.tex", ctitle ("Log Tweet count") append stats(coef se) keep(conflict_news_isr_occ_t conflict_news_isr_occ_t_1 Lconflict_news_isr_occ_t Lconflict_news_isr_occ_t_1) nocons label bdec(3) addtext (DOW FEs, Yes, Linear time trend, Yes) addstat("p value", P_v, "p value lag", P1_v, "p value sum", P2_v)

xi: newey ln_tweet_count l_conflict_news_isr_occ_t l_conflict_news_isr_occ_t_1 l_conflict_news_no_isr_occ_t_y lnvic l.lnvic lnvic_pal l.lnvic_pal occurrence l.occurrence occurrence_pal l.occurrence_pal  i.dow monthyear i.month, lag(7) force
test l_conflict_news_isr_occ_t=l_conflict_news_isr_occ_t_1
scalar P_v=r(p)
outreg2 using "$tables/table_8.tex", ctitle ("Log Tweet count") append stats(coef se) keep(l_conflict_news_isr_occ_t l_conflict_news_isr_occ_t_1) nocons label bdec(3) addtext (DOW FEs, Yes, Linear time trend, Yes) addstat("p value", P_v)

xi: newey ln_tweet_count l_conflict_news_isr_occ_t l_conflict_news_isr_occ_t_1 l_conflict_news_no_isr_occ_t_y Ll_conflict_news_isr_occ_t Ll_conflict_news_isr_occ_t_1 Ll_conflict_news_no_isr_occ_t_y lnvic l.lnvic l2.lnvic lnvic_pal l.lnvic_pal l2.lnvic_pal occurrence l.occurrence l2.occurrence occurrence_pal l.occurrence_pal l2.occurrence_pal  i.dow monthyear i.month, lag(7) force
test l_conflict_news_isr_occ_t=l_conflict_news_isr_occ_t_1
scalar P_v=r(p)
test Ll_conflict_news_isr_occ_t Ll_conflict_news_isr_occ_t_1
scalar P1_v=r(p)
test Ll_conflict_news_isr_occ_t+l_conflict_news_isr_occ_t=Ll_conflict_news_isr_occ_t_1+l_conflict_news_isr_occ_t_1
scalar P2_v=r(p)
outreg2 using "$tables/table_8.tex", ctitle ("Log Tweet count") append stats(coef se) keep(l_conflict_news_isr_occ_t l_conflict_news_isr_occ_t_1 Ll_conflict_news_isr_occ_t Ll_conflict_news_isr_occ_t_1) nocons label bdec(3) addtext (DOW FEs, Yes, Linear time trend, Yes) addstat("p value", P_v, "p value lag", P1_v,"p value sum", P2_v)

* Corresponding OLS regressions to display the R-squared
eststo clear
eststo: xi: reg ln_tweet_count conflict_news_isr_occ_t conflict_news_isr_occ_t_1 conflict_news_no_isr_occ_t_y lnvic l.lnvic lnvic_pal l.lnvic_pal occurrence l.occurrence occurrence_pal l.occurrence_pal i.dow monthyear i.month, vce(cluster monthyear)
eststo: xi: reg ln_tweet_count conflict_news_isr_occ_t conflict_news_isr_occ_t_1 conflict_news_no_isr_occ_t_y Lconflict_news_isr_occ_t Lconflict_news_isr_occ_t_1 Lconflict_news_no_isr_occ_t_y lnvic l.lnvic l2.lnvic lnvic_pal l.lnvic_pal l2.lnvic_pal occurrence l.occurrence  l2.occurrence occurrence_pal l.occurrence_pal   l2.occurrence_pal i.dow monthyear i.month, vce(cluster monthyear)
eststo: xi: reg ln_tweet_count l_conflict_news_isr_occ_t l_conflict_news_isr_occ_t_1 l_conflict_news_no_isr_occ_t_y lnvic l.lnvic lnvic_pal l.lnvic_pal occurrence l.occurrence occurrence_pal l.occurrence_pal i.dow monthyear i.month, vce(cluster monthyear)
eststo: xi: reg ln_tweet_count l_conflict_news_isr_occ_t l_conflict_news_isr_occ_t_1 l_conflict_news_no_isr_occ_t_y Ll_conflict_news_isr_occ_t Ll_conflict_news_isr_occ_t_1 Ll_conflict_news_no_isr_occ_t_y lnvic l.lnvic l2.lnvic lnvic_pal l.lnvic_pal l2.lnvic_pal occurrence l.occurrence l2.occurrence occurrence_pal l.occurrence_pal l2.occurrence_pal  i.dow monthyear i.month, vce(cluster monthyear)
esttab, se r2 star(* 0.10 ** 0.05 *** 0.01)
