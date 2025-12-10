clear all
cd "/Users/ethanoleary/Documents/NHH/Projects/DiscrimFair/Experiment/pilot_data"

import excel using "Pilot3adata.xlsx", sheet("Firststage") firstrow
drop if participant_current_app_name != "outro" | intro1playeraccepted != 1

gen iteration = 1

save pilot3data_1, replace
clear
import excel using "Pilot3adata.xlsx", sheet("Secondstage") firstrow
drop if participant_current_page_name != "Redirect" | intro1playeraccepted != 1

gen iteration = 2

append using pilot3data_1

save pilot3data_2, replace
clear
import excel using "Pilot3adata.xlsx", sheet("ThirdStage") firstrow
drop if participant_current_page_name != "Redirect" | intro1playeraccepted != 1

gen iteration = 3

append using pilot3data_2, force
save pilot3data_3, replace

clear
import excel using "Pilot3adata.xlsx", sheet("FourthStage") firstrow
drop if participant_current_page_name != "Redirect" | intro1playeraccepted != 1

gen iteration = 4

append using pilot3data_3, force
save pilot3data_4, replace

clear
import excel using "Pilot3adata.xlsx", sheet("FifthStage") firstrow
drop if participant_current_page_name != "Redirect" | intro1playeraccepted != 1

gen iteration = 5

append using pilot3data_4, force
save pilot_main, replace



bysort participantpilottreatment: tab participantgroup
bysort participantgroup: tab task1playerchosen if participantpilottreatment == 1 // Need 5 Klee chosen and 5 Kandinksy chosen
bysort participantgroup: tab task1playerchosen if participantpilottreatment == 2 // Treatment 2 balanced
bysort participantgroup: tab task1playerchosen if participantpilottreatment == 3 // Need 1 Kandinsky unchosen
bysort participantgroup: tab task1playerchosen if participantpilottreatment == 4 // Need one Klee unchosen and 4 Kandinsky unchosen


bysort intro1playerpilottreatment: sum task1playertransfer if task1playerchosen == 0

gen investmentshare = 0
replace investmentshare = task1playerinvestment300/300 if task1playerchosen == 1
replace investmentshare = task1playerinvestment100/100 if task1playerchosen == 0

label define budget_label 1 "300 token budget" 0 "100 token budget"
label values task1playerchosen budget_label

cibar investmentshare, ///
    over(task1playerchosen)  ///
	ciopts(lcolor(black) lwidth(medium) type(rcap)) ///
	barcolor(eltgreen%90 eltblue%90) ///
	baropts(lcolor(black) lwidth(vthin) fintensity(100)) ///
	graphopts( ///
	ytitle(Investment Share, size(small)) ///
	xtitle(Investment Budget, size(small)) ///
	title(Average Investment Share by Budget, size(medsmall)) ///
	legend(title("Group", size(small) margin(tiny) color(black) bexpand)) ///
	legend(ring(0) pos(2) col(1) size(small)) ///
	plotregion(fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white)) ///
	note("Note:  95% CIs Shown", span size(vsmall)))
	
graph export "/Users/ethanoleary/Documents/NHH/Projects/DiscrimFair/Experiment/Analysis/Graphs/stage3investments.pdf", as(pdf) name("Graph") replace


gen earningshare = 0
replace earningshare = outro1playerearning/300 if task1playerchosen == 1
replace earningshare = outro1playerearning/100 if task1playerchosen == 0

label define playerlbl 1 "300 tokens" 0 "100 tokens"
label values task1playerchosen playerlbl

cibar earningshare, ///
    over(task1playerchosen)  ///
	ciopts(lcolor(black) lwidth(medium) type(rcap)) ///
	barcolor(eltgreen%90 eltblue%90) ///
	baropts(lcolor(black) lwidth(vthin) fintensity(100)) ///
	graphopts( ///
	ytitle(Earnings, size(small)) ///
	xtitle(Investment Budget, size(small)) ///
	title(Average Earning (as share of budget) by Budget, size(medsmall)) ///
	legend(ring(0) pos(2) col(1) size(small)) ///
	plotregion(fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white)) ///
	note("Note:  95% CIs Shown", span size(vsmall)))
	
graph export "/Users/ethanoleary/Documents/NHH/Projects/DiscrimFair/Experiment/Analysis/Graphs/stage3earnings.pdf", as(pdf) name("Graph") replace

label variable outro1playerearning "Earnings"
	
hist outro1playerearning, width(50) color(eltgreen%90) ///
plotregion(fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white))
graph export "/Users/ethanoleary/Documents/NHH/Projects/DiscrimFair/Experiment/Analysis/Graphs/stage3earningshist.pdf", as(pdf) name("Graph") replace

label variable task1playertransfer "Transfer decision"
label define transfer_label 1 "Transfer" 0 "No transfer"
label values task1playertransfer transfer_label

label define treat_label 1 "No cost" 2 "$0.25 cost" 3 "$0.50 cost" 4 "$0.75 cost"
label values participantpilottreatment treat_label

cibar task1playertransfer if task1playerchosen == 0, over(participantpilottreatment) ///
    ciopts(lcolor(black) lwidth(medium) type(rcap)) ///
    barcolor(eltgreen%90 eltblue%90 erose%90 emidblue%90) ///
    baropts(lcolor(black) lwidth(vthin) fintensity(100)) ///
    graphopts( ///
        ytitle("Share transferring", size(small)) ///
        xtitle("Treatment group", size(small)) ///
        title("Share of individuals transferring match's fee by treatment group", size(medsmall)) ///
        legend(ring(0) pos(2) col(1) size(small)) ///
        plotregion(fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white)) ///
        note("Note:  95% CIs Shown", span size(vsmall)))
		
		graph export "/Users/ethanoleary/Documents/NHH/Projects/DiscrimFair/Experiment/Analysis/Graphs/stage3transfers.pdf", as(pdf) name("Graph") replace
