clear all
cd "/Users/ethanoleary/Documents/NHH/Projects/DiscrimFair/Experiment"

import excel using "pilot_data/Pilot2data.xlsx", firstrow
drop if participant_current_page_name != "Redirect"

sum task1playertask
rename task1playertask assign

label define assignlbl 1 "Player A" 2 "Player B"
label values assign assignlbl

graph bar (count), over(assign) blabel(bar) ///
    plotregion(fcolor(white) lcolor(white)) ///
    graphregion(fcolor(white) lcolor(white)) ///
    bar(1, bcolor(eltgreen%90)) ///
    bar(2, bcolor(eltblue%90)) ///
    ytitle("Frequency", size(small)) ///
    title("Number of Inv. Managers assigning 300 tokens to each player", size(medsmall))
	
graph export "Analysis/Graphs/stage2allocations.pdf", replace

