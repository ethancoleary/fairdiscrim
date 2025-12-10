clear all
cd "/Users/ethanoleary/Documents/NHH/Projects/DiscrimFair/Experiment/Main"

import excel using "Data.xlsx", sheet("Run2") firstrow
drop if participant_current_app_name != "outro" & participant_current_page_name != "Redirect"
drop if task1playerinvestment300 == . & task1playerinvestment100 == .



save run2, replace

clear 
import excel using "Data.xlsx", sheet("Run1") firstrow
drop if participant_current_app_name != "outro"
drop if task1playerinvestment300 == . & task1playerinvestment100 == .

append using run2 

bysort task1playertreatment: sum task1playertransfer if task1playerchosen == 0

ttest task1playertransfer if task1playertreatment > 1 & task1playerchosen==0, by(task1playertreatment)

save run1, replace

clear 
import excel using "Data.xlsx", sheet("Run3") firstrow
drop if participant_current_app_name != "outro" & participant_current_page_name != "Redirect"
drop if task1playerinvestment300 == . & task1playerinvestment100 == .

append using run1

bysort task1playertreatment: sum task1playertransfer if task1playerchosen == 0

ttest task1playertransfer if task1playertreatment > 1 & task1playerchosen==0, by(task1playertreatment)

save run3, replace

clear 
import excel using "Data.xlsx", sheet("Run4") firstrow
drop if participant_current_app_name != "outro" & participant_current_page_name != "Redirect"
drop if task1playerinvestment300 == . & task1playerinvestment100 == .

append using run3 

save run4, replace

clear 
import excel using "Data.xlsx", sheet("Run5") firstrow
drop if participant_current_app_name != "outro" & participant_current_page_name != "Redirect"
drop if task1playerinvestment300 == . & task1playerinvestment100 == .

append using run4 

save run5, replace

clear 
import excel using "Data.xlsx", sheet("Run6") firstrow
drop if participant_current_app_name != "outro" & participant_current_page_name != "Redirect"
drop if task1playerinvestment300 == . & task1playerinvestment100 == .

append using run5 

save run6, replace

clear 
import excel using "Data.xlsx", sheet("Run7") firstrow
drop if participant_current_app_name != "outro" & participant_current_page_name != "Redirect"
drop if task1playerinvestment300 == . & task1playerinvestment100 == .

append using run6, force

save run7, replace

clear 
import excel using "Data.xlsx", sheet("Run8") firstrow
drop if participant_current_app_name != "outro" & participant_current_page_name != "Redirect"
drop if task1playerinvestment300 == . & task1playerinvestment100 == .

append using run7, force

save run8, replace

clear 
import excel using "Data.xlsx", sheet("Run9") firstrow
drop if participant_current_app_name != "outro" & participant_current_page_name != "Redirect"
drop if task1playerinvestment300 == . & task1playerinvestment100 == .

append using run8, force

save run9, replace

clear 
import excel using "Data.xlsx", sheet("Run10") firstrow
drop if participant_current_app_name != "outro" & participant_current_page_name != "Redirect"
drop if task1playerinvestment300 == . & task1playerinvestment100 == .

append using run9, force

save run10, replace


clear

import excel using "Data.xlsx", sheet("Demographics1") firstrow
save demo1, replace

clear 
import excel "Data.xlsx", sheet("Demographics2") firstrow
append using demo1, force

rename Participantid participantlabel
save demos, replace

use run10, clear
sort participantlabel

gen dup = participantlabel == participantlabel[_n-1]

merge m:1 participantlabel using demos

drop if _merge == 2
count if task1playerchosen==1
count if task1playerchosen==0

bysort intro1playerKK task1playerchosen: count if task1playertreatment == 1

bysort intro1playergender: sum task1playerinvestment300 if task1playerchosen == 1
bysort intro1playergender: sum task1playerinvestment100 if task1playerchosen == 0

gen white = Ethnicitysimplified == "White"
gen black = Ethnicitysimplified == "Black"
gen asian = Ethnicitysimplified == "Asian"
gen male = intro1playergender == 2



******************
**** GRAPHS ****
******************

rename task1playertreatment treatment
rename task1playerchosen chosen
rename task1playertransfer transfer
rename outro1playerallocation_fair fair_view

gen conservative = outro1playerpolitical_social > 3 & outro1playerpolitical_economi > 3
gen ineq_toomuch = outro1playerinequality == 3

bysort treatment: sum transfer if chosen == 0

ttest transfer if chosen==0 & treatment != 3, by(treatment)
ttest transfer if chosen==0 & treatment != 1, by(treatment)
ttest transfer if chosen==0 & treatment != 2, by(treatment)

gen ethnicity = 0
replace ethnicity = 1 if white == 1
replace ethnicity = 2 if black == 1
replace ethnicity = 3 if asian == 1
replace ethnicity = 4 if ethnicity == 0

gen pastdiscrim = outro1playerdiscrim_work == 1
rename  outro1playerallocation_eff eff_view

save data, replace

drop if chosen == 1

collapse (mean) meant= transfer (sd) sdt=transfer (count) n=transfer, by(treatment)
generate hit = meant + invttail(n-1,0.025)*(sdt / sqrt(n))
generate lot = meant - invttail(n-1,0.025)*(sdt / sqrt(n))

graph twoway (bar meant treatment, color(eltgreen%90) barwidth(0.7)) (rcap hit lot treatment), ///
 xtitle("") ytitle("") xlabel(1 "Random" 2 "Computer" 3 "Human", noticks) ///
 graphregion(fcolor(white) lcolor(white)) ///
 plotregion(fcolor(white) lcolor(white)) ///
 ytitle("Share of participants transferring") ///
 yscale(range(0 0.6)) ylabel(0(0.1)0.6) ysize(8) ///
 legend(off) ///
 	plotregion(fcolor(white) lcolor(white)) ///
    graphregion(fcolor(white) lcolor(white) lwidth(none))

 use data, clear
 drop if chosen == 1
 
 collapse (mean) meanf= fair_view (sd) sdf=fair_view (count) n=fair_view, by(treatment)
generate hif = meanf + invttail(n-1,0.025)*(sdf / sqrt(n))
generate lof = meanf - invttail(n-1,0.025)*(sdf / sqrt(n))

graph twoway (bar meanf treatment, color(eltgreen%90) barwidth(0.7)) (rcap hif lof treatment), ///
 xtitle("") ytitle("") xlabel(1 "Random" 2 "Computer" 3 "Human", noticks) ///
 graphregion(fcolor(white) lcolor(white)) ///
 plotregion(fcolor(white) lcolor(white)) ///
 ytitle("Mean fairness perception") ///
 yscale(range(1 5)) ylabel(1(0.5)5) ysize(8) ///
 legend(off) ///
 	plotregion(fcolor(white) lcolor(white)) ///
    graphregion(fcolor(white) lcolor(white) lwidth(none))
 
 use data, clear
 drop if chosen == 1
 
 label define gen 0 "Female" 1 "Male", replace
 label values male gen
 
cibar transfer, over(male treatment) ///
 barcolor(eltgreen%90 eltblue%90 eltgreen%90 eltblue%90 eltgreen%90 eltblue%90) ///
 graphopts(xlabel(1.5 "Random" 4.2 "Computer" 6.8 "Human", noticks) ///
 	plotregion(fcolor(white) lcolor(white)) ///
    graphregion(fcolor(white) lcolor(white) lwidth(none)) ///
	yscale(range(0 0.6)) ylabel(0(0.1)0.6))
	
cibar fair_view, over(male treatment) ///
 barcolor(eltgreen%90 eltblue%90 eltgreen%90 eltblue%90 eltgreen%90 eltblue%90) ///
 graphopts(xlabel(1.5 "Random" 4.2 "Computer" 6.8 "Human", noticks) ///
 	plotregion(fcolor(white) lcolor(white)) ///
    graphregion(fcolor(white) lcolor(white) lwidth(none)) ///
	yscale(range(1 5)) ylabel(1(0.5)5))
	


label define eth 1 "White" 2 "Black" 3 "Asian" 4 "Other"
label values ethnicity eth
	
cibar transfer, over(ethnicity treatment) ///
 graphopts(xlabel(2.5 "Random" 7.2 "Computer" 12"Human", noticks) ///
 	plotregion(fcolor(white) lcolor(white)) ///
    graphregion(fcolor(white) lcolor(white) lwidth(none)) ///
	yscale(range(0 0.6)) ylabel(0(0.1)0.6))
	
cibar fair_view, over(ethnicity treatment) ///
 graphopts(xlabel(2.5 "Random" 7.2 "Computer" 12 "Human", noticks) ///
 	plotregion(fcolor(white) lcolor(white)) ///
    graphregion(fcolor(white) lcolor(white) lwidth(none)) ///
	yscale(range(1 5)) ylabel(1(0.5)5))
	

label define pd 0 "No" 1 "Yes"
label values pastdiscrim pd

cibar transfer, over(pastdiscrim treatment) ///
 graphopts(xlabel(1.5 "Random" 4.2 "Computer" 6.8"Human", noticks) ///
 	plotregion(fcolor(white) lcolor(white)) ///
    graphregion(fcolor(white) lcolor(white) lwidth(none)) ///
	yscale(range(0 0.6)) ylabel(0(0.1)0.6))
	
cibar fair_view, over(pastdiscrim treatment) ///
 graphopts(xlabel(1.5 "Random" 4.2 "Computer" 6.8"Human", noticks) ///
 	plotregion(fcolor(white) lcolor(white)) ///
    graphregion(fcolor(white) lcolor(white) lwidth(none)) ///
	yscale(range(1 5)) ylabel(1(0.5)5))


	
	******** REGRESSIONS *********
	
 label define gen 0 "Female" 1 "Male", replace
 label values male gen	
	
	
label define eth 1 "White" 2 "Black" 3 "Asian" 4 "Other"
label values ethnicity eth

gen pastdiscrim = outro1playerdiscrim_work == 1 & outro1playerdiscrim_work_pref == 1

label define pd 0 "No" 1 "Yes"
label values pastdiscrim pd

gen fair_view2 = 0
replace fair_view2 = 1 if fair_view <3
replace fair_view2 = 2 if fair_view == 3
replace fair_view2 = 3 if fair_view > 3

gen eff_view2 = 0
replace eff_view2 = 1 if eff_view <3
replace eff_view2 = 2 if eff_view == 3
replace eff_view2 = 3 if eff_view > 3

rename CC pastdiscrimrace
rename CB pastdiscrimgender

***** BASELINE
reg transfer i.treatment if chosen == 0
reg fair_view i.treatment
reg fair_view2 i.treatment
reg eff_view i.treatment
reg eff_view2 i.treatment

reg fair_view i.treatment chosen
reg fair_view2 i.treatment chosen
reg eff_view i.treatment chosen
reg eff_view2 i.treatment chosen

forvalues i = 1/3 {
	gen chosent`i' = 0
replace chosent`i' = 1 if chosen == 1 & treatment == `i'
}

reg fair_view i.treatment chosen chosent2 chosent3
reg fair_view2 i.treatment chosen chosent2 chosent3
reg eff_view i.treatment chosen chosent2 chosent3
reg eff_view2 i.treatment chosen chosent2 chosent3

***** MALE CONTROL
reg transfer i.treatment male if chosen == 0
reg fair_view i.treatment male chosen chosent2 chosent3
reg fair_view2 i.treatment male chosen chosent2 chosent3
reg eff_view i.treatment male chosen chosent2 chosent3
reg eff_view2 i.treatment male chosen chosent2 chosent3

***** ETHNICITY CONTROL
reg transfer i.treatment male i.ethnicity if chosen == 0
reg fair_view i.treatment male i.ethnicity chosen chosent2 chosent3
reg fair_view2 i.treatment male i.ethnicity chosen chosent2 chosent3
reg eff_view i.treatment male i.ethnicity chosen chosent2 chosent3
reg eff_view2 i.treatment male i.ethnicity chosen chosent2 chosent3

***** PAST DISCRIM CONTROL
reg transfer i.treatment male i.ethnicity pastdiscrim if chosen == 0
reg fair_view i.treatment male i.ethnicity pastdiscrim chosen chosent2 chosent3
reg fair_view2 i.treatment male i.ethnicity pastdiscrim chosen chosent2 chosent3
reg eff_view i.treatment male i.ethnicity pastdiscrim chosen chosent2 chosent3
reg eff_view2 i.treatment male i.ethnicity pastdiscrim chosen chosent2 chosent3

***** POLITICAL CONTROL
rename outro1playerpolitical_social sociopolitic
rename outro1playerpolitical_economi ecopolitic

reg transfer i.treatment male i.ethnicity pastdiscrim sociopolitic ecopolitic if chosen == 0
reg fair_view i.treatment male i.ethnicity pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3
reg fair_view2 i.treatment male i.ethnicity pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3
reg eff_view i.treatment male i.ethnicity pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3
reg eff_view2 i.treatment male i.ethnicity pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3

******* WITHIN TREATMENT
// T1
reg transfer male i.ethnicity pastdiscrim sociopolitic ecopolitic if chosen == 0 & treatment == 1
reg fair_view male i.ethnicity pastdiscrim sociopolitic ecopolitic chosen if treatment == 1
reg fair_view2 male i.ethnicity pastdiscrim sociopolitic ecopolitic chosen if treatment == 1
reg eff_view male i.ethnicity pastdiscrim sociopolitic ecopolitic chosen if treatment == 1
reg eff_view2 male i.ethnicity pastdiscrim sociopolitic ecopolitic chosen if treatment == 1

// T2
reg transfer male i.ethnicity pastdiscrim sociopolitic ecopolitic if chosen == 0 & treatment == 2
reg fair_view male i.ethnicity pastdiscrim sociopolitic ecopolitic chosen if treatment == 2
reg fair_view2 male i.ethnicity pastdiscrim sociopolitic ecopolitic chosen if  treatment == 2
reg eff_view male i.ethnicity pastdiscrim sociopolitic ecopolitic chosen if treatment == 2
reg eff_view2 male i.ethnicity pastdiscrim sociopolitic ecopolitic chosen if treatment == 2

// T3
reg transfer male i.ethnicity pastdiscrim sociopolitic ecopolitic if chosen == 0 & treatment == 3
reg fair_view male i.ethnicity pastdiscrim sociopolitic ecopolitic chosen if treatment == 3
reg fair_view2 male i.ethnicity pastdiscrim sociopolitic ecopolitic chosen if  treatment == 3
reg eff_view male i.ethnicity pastdiscrim sociopolitic ecopolitic chosen if treatment == 3
reg eff_view2 male i.ethnicity pastdiscrim sociopolitic ecopolitic chosen if treatment == 3


********* WITHIN GROUPS
 // WHITES
reg transfer i.treatment male pastdiscrim sociopolitic ecopolitic if chosen == 0 & white == 1
reg fair_view i.treatment male pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 1
reg fair_view2 i.treatment male pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 1
reg eff_view i.treatment male  pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 1
reg eff_view2 i.treatment male pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 1

// WHITE MALES
reg transfer i.treatment pastdiscrim sociopolitic ecopolitic if chosen == 0 & white == 1 & male == 1
reg fair_view i.treatment pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white  == 1 & male == 1
reg fair_view2 i.treatment pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 1 & male == 1
reg eff_view i.treatment  pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 1 & male == 1
reg eff_view2 i.treatment pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 1 & male == 1

// WHITE NON-MALES
reg transfer i.treatment pastdiscrim sociopolitic ecopolitic if chosen == 0 & white == 1 & male == 0
reg fair_view i.treatment pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white  == 1 & male == 0
reg fair_view2 i.treatment pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 1 & male == 0
reg eff_view i.treatment  pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 1 & male == 0
reg eff_view2 i.treatment pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 1 & male == 0

// NON-WHITES

reg transfer i.treatment male pastdiscrim sociopolitic ecopolitic if chosen == 0 & white == 0
reg fair_view i.treatment male pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 0
reg fair_view2 i.treatment male pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 0
reg eff_view i.treatment male  pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 0
reg eff_view2 i.treatment male pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 0

// NON-WHITE MALES
reg transfer i.treatment pastdiscrim sociopolitic ecopolitic if chosen == 0 & white == 0 & male == 1
reg fair_view i.treatment pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white  == 1 & male == 1
reg fair_view2 i.treatment pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 0 & male == 1
reg eff_view i.treatment  pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 0 & male == 1
reg eff_view2 i.treatment pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 0 & male == 1

// NON-WHITE NON-MALES
reg transfer i.treatment pastdiscrim sociopolitic ecopolitic if chosen == 0 & white == 0 & male == 0
reg fair_view i.treatment pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white  == 1 & male == 0
reg fair_view2 i.treatment pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 0 & male == 0
reg eff_view i.treatment  pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 0 & male == 0
reg eff_view2 i.treatment pastdiscrim sociopolitic ecopolitic chosen chosent2 chosent3 if white == 0 & male == 0

// CONSERVATIVES
reg transfer i.treatment male i.ethnicity pastdiscrim ecopolitic if chosen == 0 & sociopolitic > 3
reg fair_view i.treatment male i.ethnicity  pastdiscrim ecopolitic chosen chosent2 chosent3 if sociopolitic > 3
reg fair_view2 i.treatment male i.ethnicity  pastdiscrim ecopolitic chosen chosent2 chosent3 if sociopolitic > 3
reg eff_view i.treatment male i.ethnicity   pastdiscrim ecopolitic chosen chosent2 chosent3 if sociopolitic > 3
reg eff_view2 i.treatment male i.ethnicity  pastdiscrim ecopolitic chosen chosent2 chosent3 if sociopolitic > 3


******** EXPLORING THE NULL
bysort treatment transfer: sum fair_view if chosen == 0

// Those that transfer do believe it is unfair

ttest transfer if chosen == 0 & treatment != 1 & fair_view2 == 1, by(treatment)
ttest transfer if chosen == 0 & treatment != 2 & fair_view2 == 1, by(treatment)
ttest transfer if chosen == 0 & treatment != 3 & fair_view2 == 1, by(treatment)

ttest transfer if chosen == 0 & treatment != 1 & fair_view2 == 2, by(treatment)
ttest transfer if chosen == 0 & treatment != 2 & fair_view2 == 2, by(treatment)
ttest transfer if chosen == 0 & treatment != 3 & fair_view2 == 2, by(treatment)

ttest transfer if chosen == 0 & treatment != 1 & fair_view2 == 3, by(treatment)
ttest transfer if chosen == 0 & treatment != 2 & fair_view2 == 3, by(treatment)
ttest transfer if chosen == 0 & treatment != 3 & fair_view2 == 3, by(treatment)


by


