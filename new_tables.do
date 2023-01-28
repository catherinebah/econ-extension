set more off

* Define main directory
global main="Z:\replication\ludo\"

* Define data directory
global dta="$main/dta/"

* Define tables directory
global tables="$main/tables/"

* Define figures directory
global figures="$main/figures/"


************************************************************************
** Figure 4. Israeli and Palestinian Attacks and Other Predictable 
**           and Exogenous Newsworthy Events in the US
************************************************************************

use "$dta/data.dta", clear

gen no_major_events=1-lead_maj_events
preserve

* Panel A: US attacks and newsworthy events

reg occurrence_us lead_maj_events no_major_events, nocons
test lead_maj_events=no_major_events
regsave, ci
foreach x in coef ci_lower ci_upper {
gen `x'_100 = 100*`x'
}
keep var *_100 
encode var, gen(events)
gen x = _n
gen barposition = cond(events==1, _n, _n+0.5)
gen coef_2dec = coef_100
format coef_2dec %9.2f
local c1 = round(coef_2dec[1],0.01)
local c2 = round(coef_2dec[2],0.01)

#delimit ;
twoway (bar coef_100 barposition if events == 1, fcolor(navy)) 
(bar coef_100 barposition if events == 2, fcolor(navy)) 
(rcap ci_lower_100 ci_upper_100 barposition, legend(off)
lwidth(medthick) lcolor(darkblue)
yscale(range(0(1)10)) ytick(0(1)10) ylabel(0(1)10)
xscale(range(0(0.5)3.5)) xtitle("") 
xlabel(1 "Major political/sport events" 2.5 "No major political/sports events")
title("% of days with US attacks in Pakistan", color(black) size(medium))
text(3 0.9 "`c1'%", place(e) color(white) xoffset(-2) yoffset(5))
text(3 2.4 "`c2'%", place(e) color(white) xoffset(-2) yoffset(5))
graphregion(color(white))) ;
#delimit cr
graph export "$figures/figure_4_a.pdf", replace
restore


****************************************************************************************************
** Table 5. Attacks and Next-day News Pressure Driven by Predictable Political and Sports Events
****************************************************************************************************

use "$dta/data.dta", clear

gen date2 = date(date, "DMY")
format date2 %d
tsset date2
sort date2

** Panel A: Israeli Attacks and Predictable Newsworthy Events

*use "$dta/replication_file1.dta", clear
*sort date

** Panel A: Israeli Attacks and Predictable Newsworthy Events

xi:  reg occurrence_us         lead_maj_events i.month i.year i.dow if gaza_war==0 , first cluster(monthyear)
gen sample_rf=1 if e(sample)
outreg2 using "$tables/table_5a.xls", append ctitle("Occurrence, Reduced form") keep(lead_maj_events) nocons label bdec(3)

cap drop mon1-mon12 day1-day7 year1-year12
tab month, gen(mon)
tab dow, gen(day)
tab year, gen(year)
	 
#delimit;
     xi: glm vic_us 
     lead_maj_events 
	 occurrence_pal_1 occurrence_pal_2_7 occurrence_pal_8_14
	 i.month i.year i.dow if  gaza_war==0, family(nbinom ml)
	 vce(cluster monthyear);
#delimit cr
outreg2 using "$tables/table_5a.xls", append ctitle("Num. victims, Reduced form") keep(lead_maj_events) nocons label bdec(3)

* Corresponding OLS regressions estimated below to display pseudo R-squared
eststo clear
eststo: xi: nbreg victims_isr lead_maj_events occurrence_pal_1 occurrence_pal_2_7 occurrence_pal_8_14 i.month i.year i.dow if  gaza_war==0, vce(cluster monthyear)
esttab, se pr2 star(* 0.1 ** 0.05 *** 0.01)