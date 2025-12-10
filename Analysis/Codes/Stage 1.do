clear all
cd "/Users/ethanoleary/Documents/NHH/Projects/DiscrimFair/Experiment"

import excel using "pilot_data/Pilot1data.xlsx", sheet("Pilot1") firstrow
drop if participant_current_page_name != "Redirect"

bysort intro1playergender: sum task1playerinvestment

gen investmentshare = participantinvestment/200
bysort intro1playerKK: sum investmentshare

label define group_label 1 "Klee" 2 "Kandinsky"
label values intro1playerKK group_label
	
cibar investmentshare, ///
    over(intro1playerKK)  ///
	ciopts(lcolor(black) lwidth(medium) type(rcap)) ///
	barcolor(eltgreen%90 eltblue%90) ///
	baropts(lcolor(black) lwidth(vthin) fintensity(100)) ///
	graphopts( ///
	ytitle(Investment Share, size(small)) ///
	xtitle(Group, size(small)) ///
	title(Average Investment Share by Group, size(medsmall)) ///
	legend(title("Group", size(small) margin(tiny) color(black) bexpand)) ///
	legend(ring(0) pos(3) col(1) size(small)) ///
	plotregion(fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white)) ///
	note("Note:  95% CIs Shown", span size(vsmall)))
	
graph export "Analysis/Graphs/stage1investments.pdf", replace


************ BONUSES ************
keep participantlabel outro1playerearning
rename outro1playerearning bonus
replace bonus = bonus/100
gen bonus_gbp = bonus * 0.74
replace bonus_gbp = round(bonus_gbp, .01)
format bonus_gbp %9.2f
drop bonus

export excel using pilot1bonus.xlsx, replace

	