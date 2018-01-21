*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions  T20 cricket matches
Dataset Name:  T20 cricket matches
https://github.com/stat6250/team-3_project1/blob/master/t20_matches
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates t20_matches analytic dataset _analytic_file;
%include '.\STAT6250-02_s17-team-3_project1_data_preparation.sas;



title1
'Research Question: What is the average of the respective winning rate?'
;
'Rationale: This will provide me the average  for winning,amd we can see the mean for winning.';

*
Methodology: Use PROC MEAN to calculate average of winning level each team?'


Limitations: This methodology does not account for districts with missing data,
nor does it attempt to validate data in any way.

possible Follow-up Steps: More carefully clean the values of the variable
t20_matches  so that the means we can see the avrage of winnig for each team.

;
proc print
        noobs
        data t20_matches=(obs=20)
    ;
   match_id
       winner
    ;
    var
        t20_matches
    ;
run;




title1
'Research Question: what team is usually winning by run?'
;

title2
'Rationale: This would help to see which team usually win by win by runs .'
;


*
Methodology: to see the team who has the highest chance to win by runs.

Limitations: This methodology does not account for schools with missing data,
nor does it attempt to validate data in any way,

Possible Follow-up Steps: More carefully clean the values of the variable
t20_matches so that the statistics computed do not include any
possible illegal values.
;

    
   proc sort data= t20_matches;
by winner;
run; 
proc print noobs data= win_by_runs(obs=20);
,     var win_by_runs
run;



'Research Question: What is the mean of teams winnig by balls remaining?


'Rationale: This would help the avrage team won with balls remaining  .'
;
*
Methodology: Printing the average value of balls remaining.

Limitations: This methodology does not account for any  missing data,
nor does it attempt to validate data in any way.

Possible Follow-up Steps: More carefully clean the values of the variable
balls_remaining so that the statistics computed do not include any
possible illegal values, and better handle missing data.
;

proc print noobs data= t20_matcheswhere winner EQ 'balls_remaining';
     var winner;
run;
