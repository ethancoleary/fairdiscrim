clear all
cd "/Users/ethanoleary/Documents/NHH/Projects/DiscrimFair/Experiment/pilot_data"

use pilot_main, clear

**** MATCHING *****

gen group_treatment_chosen = 0

forvalues t = 1/4 {

forvalues g = 1/2 {
	
	forvalues c = 0/1 {
		
		replace group_treatment_chosen = `g'`t'`c' if participantgroup == `g' & participantpilottreatment == `t' & task1playerchosen == `c'
		
	}
	
}

}

rename group_treatment_chosen gtc
rename outro1playerparticipation_fee outro1playerpf
gen full_bonus = outro1playerearning

keep participantlabel participantid_in_session gtc participantinvestment task1playerchosen outro1playerlottery outro1playerearning participantpilottreatment task1playertransfer full_bonus outro1playerpf iteration

tab gtc

sort gtc
bysort gtc (participantid_in_session): gen group_id = _n
bysort gtc: gen group_size = _N
gen matching_gtc = gtc

forvalues t = 1/4 {
replace matching_gtc = 2`t'1 if gtc == 1`t'0
replace matching_gtc = 1`t'0 if gtc == 2`t'1
replace matching_gtc = 2`t'0 if gtc == 1`t'1
replace matching_gtc = 1`t'1 if gtc == 2`t'0
}


save full_data, replace

drop if task1playerchosen == 1

set seed 12345
gen matching = runiform()
bysort gtc (matching): gen random_id = _n

replace full_bonus = full_bonus + (100*outro1playerpf)

save unchosens, replace

gen bonus_gbp = full_bonus * 0.74

keep participantlabel outro1playerearning bonus_gbp iteration
save unchosenbonus, replace

use full_data, clear

drop if task1playerchosen == 0

foreach var of varlist _all {
    rename `var' `var'_chosen
}

rename group_id_chosen random_id
drop gtc_chosen
rename matching_gtc_chosen gtc

merge 1:m random_id gtc using "/Users/ethanoleary/Documents/NHH/Projects/DiscrimFair/Experiment/pilot_data/unchosens.dta", nogen

replace full_bonus = full_bonus_chosen + ((1-task1playertransfer) * 50)

gen bonus_gbp = full_bonus * 0.74
drop iteration
rename iteration_chosen iteration
keep participantlabel_chosen bonus_gbp outro1playerearning_chosen iteration
rename participantlabel_chosen participantlabel

append using unchosenbonus
drop if bonus_gbp == 0
replace bonus_gbp = bonus_gbp/100
replace bonus_gbp = round(bonus_gbp, .01)
format bonus_gbp %9.2f


preserve

drop if iteration != 1
sort outro1playerearning_chosen
keep participantlabel bonus_gbp
export excel using pilot3bonus1.xlsx, replace

restore

preserve

drop if iteration != 2
keep participantlabel bonus_gbp
export excel using pilot3bonus2.xlsx, replace
restore
preserve

drop if iteration != 3
keep participantlabel bonus_gbp
export excel using pilot3bonus3.xlsx, replace
restore
preserve

drop if iteration != 4
keep participantlabel bonus_gbp
export excel using pilot3bonus4.xlsx, replace
restore
preserve

drop if iteration != 5
keep participantlabel bonus_gbp
export excel using pilot3bonus5.xlsx, replace






