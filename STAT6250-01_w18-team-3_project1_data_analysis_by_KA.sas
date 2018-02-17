*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic data set to address several research 
questions regarding T20 matches in the Sport of Cricket, specifically in the 
years 2003-2017.

Data set name: T20 matches created in external file
STAT6250-01_team-3_project1_data_preparation.sas, which is assumed to be 
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset T20_matches_file;
%include '.\STAT6250-01_w18-team-3_project1_data_preparation.sas';



title1 
'Research Question: Which teams have scored highest? ?'
;
    
title2 
'Rationale: This would help determine the ranking of teams in terms of strike rate in matches '
;

footnote1
'Based on the output, most of the teams scoring such high runs have lost a very few wickets in the whole innings.'
;

footnote2
'Moreover, it is observed that they have played all the overs with none left to spare.'
;

footnote3
'In general, the margin of difference in the win is very large.'
;
*
Methodology: Use PROC PRINT to print just the first twenty observations from
the temporary dataset created in the corresponding data-prep file.

Limitations: This methodology does not account for consistency of teams scoring
high every match, they could play very excellent or would score very low and 
lose the game.

Possible Follow-up Steps: Take the average of scores of a team in each and 
every match, and then determine the possible highest score.
;


proc sort data=matches_raw out=matches_raw_i1_sorted;
    by descending innings1_runs;
run;

proc sort data=matches_raw out=matches_raw_i2_sorted;
    by descending innings2_runs;
run;


proc print data=matches_raw_i1_sorted (obs=10);
    var
        match_details 		
	winner 		
	innings1 			    
	innings1_runs ;
run;



proc print data=matches_raw_i2_sorted (obs=10);
    var
        match_details
	winner
	innings2
	innings2_runs
    ;
run;
title;
footnote;


title1 
'Research Question: What are win/lose statistics for teams batting in 1st and 2nd innings? '
;
    
title2  
'Rationale: This can help decide the win/loss rate of a team and decide their rankings.'
;

footnote1
'Based on the calculations, the team can decide whether to bowl/bat first
 depending on their track record and increase their chances of winning.'
;

footnote2
'The team can devise a strategy to defeat the opponent based on the choice of play.'
;

footnote3
"In addition, more analysis is needed into the players and their play statistics."
;

*
Methodology:Use PROC PRINT to print the number of innings the team has 
played and won with the runs scored in the 1st innings.

Limitations: This methodology does not account for player ratings and their 
play statistics over their career.

Possible Follow-up Steps: Check up with players from teams on their career 
background and their present statistics to predict an estimate of match 
outcome.
;





proc sql;
	select count(inning1_winner) as Count1 
	from matches_raw_q2 where inning1_winner=1;
quit;


proc sql;
	select count(inning2_winner) as Count2 
	from matches_raw_q2 where inning2_winner=1;
quit;

title;
footnote;

title1 
'Research Question: How many matches were improvised by D/L method?'
;
     
title2 
'Rationale: Use optimal venues and dates to fix matches so as to avoid sudden changes in weather resulting in implementation of D/L method '
;

footnote1
'Based on the data,the team can change its strategy to meet the new target(runs and overs considered) by changing its lineup.';

footnote2
'However, this analysis does not yield complete inference of conditions on application of D/L method. '
;

footnote3
'In addition, more analysis is needed into the players and their play statistics.'
;
*
Methodology: Use proc print to print the number of teams playing the 
number of overs in D/L method to get an idea of number of overs played
in each match in D/L match along with the target runs.

Limitations: Even after using these methods, it is almost impossible 
to estimate which matches would end up implementing the D/L method.

Follow-up Steps: A possible follow-up to this approach could use an 
inferential statistical technique like regression or forecasting if 
all the variables are provided for the calculation.
;


proc sql;
	select count(*),D_L_method
	from matches_raw group by D_L_method;
quit;

run;
title;
footnote;
