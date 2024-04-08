

* PART 1: Table 5 and Figures 1, 2 
clear all

cd "C:\Users\galamboslajos\Desktop\2015_0112_data"

use "CA_schools_es.dta"

*Generate running variable
gen norm = api_rank - 643
replace norm = api_rank - 600 if stype == "M"
replace norm = api_rank - 584 if stype == "H"

**Restrict sample to elementary schools**
keep if stype == "E"

gen ind = 0 
replace ind = 1 if api_rank <= 643

gen ind_norm = ind*norm


**Keep Observations within 200 API window of cutoff**
keep if abs(norm) < 100


**Normalize test  scores 
sum mathscore

replace mathscore = (mathscore - r(mean))/r(sd)

sum readingscore

replace readingscore = (readingscore - r(mean))/r(sd)

gen average_score = (mathscore+readingscore)/2

**Falsification Index

*Generate lagged test scores
sort cds year
bysort cds: gen lag_average_score = average_score[_n-1]

*Generage index with various characteristics
* for figure 1
reg average_score total pct_wh pct_hi percentfrl fte_t fte_a fte_p yrs_teach yrs_dist lag_average_score if year < 2005 & norm < 19.099 & norm > -19.099
predict y_hat3

* for figure 2
gen one = 1

**TABLE 5**
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(robust)

reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)

reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(robust)

reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)


reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(robust)

reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)



*Generate bins for figures
local enr = "norm"
local bin =3

gen bin = round(`enr'+`bin'/2, `bin')
replace bin= bin-`bin'/2

replace bin = . if norm == 0 & bin == 1.5


*Figure 1*
egen y_hat3_bin = mean(y_hat3) if year < 2005, by(bin)
twoway (scatter  y_hat3_bin bin if bin < 50 & bin > -50 & year < 2005, ///
	ylabel(#5) xline(0) xti("API in 2003 relative to cutoff") ///
	yti("Predicted test score") ///
	title("Figure 1. Predicted Pretreatment Test Scores Using School Characteristics for Elementary Schools", size(small)))
graph export "output/figure1.png", as(png) replace



*Figure 2*
egen one_bin = total(one) if year ==2005, by(bin)
twoway (scatter one_bin bin if bin < 100 & bin > -100 , ylabel(#5) xline(0) ///
	xti("API in 2003 relative to cutoff") yti("Number of schools")), ///
	title("Figure 2. Distribution of Elementary Schools Around Eligibility Threshold", size(small))
graph export "output/figure2.png", as(png) replace
*-------------------------------------------------------------------------------
* PART 2: Figures 3 (Panel A) 
clear all

use "CA_schools_es.dta"

*Generate running variable
gen norm = api_rank - 643
replace norm = api_rank - 600 if stype == "M"
replace norm = api_rank - 584 if stype == "H"

*** 
keep if stype == "E"

gen ind = 0 
replace ind = 1 if api_rank <= 643

gen ind_norm = ind*norm

*Keep the observation from -200 API window of cutoff
keep if norm > -200


**Normalize test  scores 
sum mathscore

replace mathscore = (mathscore - r(mean))/r(sd)

sum readingscore

replace readingscore = (readingscore - r(mean))/r(sd)

gen average_score = (mathscore+readingscore)/2

**Falsification Index

*Generate lagged test scores
sort cds year
bysort cds: gen lag_average_score = average_score[_n-1]


*Generate bins for figures
local enr = "norm"
local bin = 7

gen bin = round(`enr'+`bin'/2, `bin' )
replace bin= bin-`bin'/2

gen bin = round((enr + bin) / 2, bin)
replace bin = bin - bin / 2

local enr = "norm"
local bin = 7


gen bin_rounded = round((`enr' + `bin') / 2, `bin')
replace bin_rounded = bin_rounded - (`bin' / 2)

replace bin = . if norm == 0 & bin == 3.5

*Figure 3, Panel A*
merge m:1 cds using "williams_full_apportionment_schedule.dta"
tab _merge
gen list = 0
replace list = 100 if _merge == 3 // list = 100 instead of 1 

replace list = . if year != 2005

egen list_bin = mean(list) , by(bin)

scatter list_bin bin if year == 2005, xline(0) xti("API in 2003") ///
	yti("Dollars per student") ///
	title("Panel A. School-level assignment of IMWC textbook funding per student in 2005", size(small))
graph export "output/figure3A.png", as(png) replace
