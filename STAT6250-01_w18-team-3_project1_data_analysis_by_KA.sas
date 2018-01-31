*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic data set to address several research questions 
regarding T20 matches in the Sport of Cricket, specifically in the years 2003-2017.

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
    'Research Question: Which teams have scored highest? ?';
    
title2 
    'Rationale: This would help determine the ranking of teams in terms of strike rate in matches ';

footnote1
'Based on the above output, most of the teams scoring such high runs have lost a very few wickets in the whole innings.';

footnote2
'Moreover, it is observed that they have played all the overs with none left to spare.';

footnote3
'In general, the margin of difference in the win is very large.';
*
Methodology: Use PROC PRINT to print just the first twenty observations from
the temporary dataset created in the corresponding data-prep file.

Limitations: This methodology does not account for consistency of teams scoring
high every match, they could play very excellent or would score very low and lose 
the game.

Possible Follow-up Steps: Take the average of scores of a team in each and every
match, and then determine the possible highest score.
;
proc print
        noobs
        data=T20_Matches_analytic_file_temp(obs=20)
    ;
    id
        match_id
    ;
    var
        innings1_runs
    ;
run;
title;
footnote;



title1
    'Research Question: What are win/lose statistics for teams batting/bowling first? ';
    
title2  
    'Rationale: This can help decide the win/loss rate of a team and decide their rankings.';

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
Methodology: Compute number of wins by counting winner variable outcome for a specific team.

Limitations: This methodology does not account for player ratings and their play statistics 
over their career.

Possible Follow-up Steps: Check up with players from teams on their career background
and their present statistics to predict an estimate of match outcome.
;
proc means
        min q1 median q3 max
        data=T20_Matches_analytic_file_temp(obs=20)
    ;
    class
        match_details
    ;
    var
        winner
    ;
run;
title;
footnote;



title1 
    'Research Question: How many matches were improvised by D/L method (target runs is reduced due to weather and time factors)?';
     
title2 
    'Rationale: Use optimal venues and dates to fix matches so as to avoid sudden changes in weather 
     resulting in implementation of D/L method ';

footnote1
"Based on the above output, there's no clear inferential pattern for predicting the percentage eligible for free/reduced-price meals under the National School Lunch Program based on school enrollment since cell counts don't tend to follow trends for increasing or decreasing consistently."
;

footnote2
'However, this is an incredibly course analysis since only quartiles are used, so a follow-up analysis using a more sensitive instrument (like beta regression) might find useful correlations.'
;
*
Methodology: Use proc means to study the five-number summary of each variable,
create formats to bin values of Enrollment_K12 and Percent_Eligible_FRPM_K12
based upon their spread, and use proc freq to cross-tabulate bins.

Limitations: Even though predictive modeling is specified in the research
questions, this methodology solely relies on a crude descriptive technique
by looking at correlations along quartile values, which could be too coarse a
method to find actual association between the variables.

Follow-up Steps: A possible follow-up to this approach could use an inferential
statistical technique like beta regression.
;
proc freq
        data=FRPM1516_analytic_file
    ;
    table
        Enrollment_K12*Percent_Eligible_FRPM_K12
        / missing norow nocol nopercent
    ;
    format
        Enrollment_K12 Enrollment_K12_bins.
        Percent_Eligible_FRPM_K12 Percent_Eligible_FRPM_K12_bins.
    ;
run;
title;
footnote;
