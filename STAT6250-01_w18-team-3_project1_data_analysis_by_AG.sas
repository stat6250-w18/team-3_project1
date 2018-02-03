*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding 6000 cricket matches

Dataset Name: T20 cricket mathces created in external file
STAT6250-01_w18-team-3_project1_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;


* environmental setup;

* set relative file import path to current directory (using standard SAS trick;
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


** load external file that generates analytic dataset;
%include '.\STAT6250-01_w18-team-3_project1_data_preparation.sas'; 

*
Methodology: Use PROC PRINT to print out the top twenty winner observations
from the sorted home runs temporary dataset created in the data prep file. 
top 20 winner .

Limitations: None

Possible Follow-up Steps: Use PROC MEANS to compute the top 20 winner
for the data set and see just how far above this  the best 20 teams. 

;

title1
'Research Question: who are the top twenty teams winner?'
;

title2:
'Rationale : this would help us to plan a match amongst them to find out the the ultimate winner.'
;
footnote1
'This number will be used to help answer the following three research questions regarding the top twenty .'
;

proc print
        noobs
        data =matches_analytic_file (obs=20)
    ;
    id
        match_id
     ;
     
     var
          winner
    ;
run;
title;
footnote;


title1
'Research Question: Who are the top 20 win by runs  with the highest number of home win?'
;

title2
'Rationale: A home win by runs is a good and most impressive thing one can do in cricket , so more of these should increase the chance to be champions of cricke.'
;

footnote1
'The average win by runs  for this dataset is 31.32071. While there are a couple outliers. The top twenty winner by win by runs numbers definitely have larger than any one . '
;

footnote2
'This shows that if a team  can be skilled enough to win by win by runs, iy=t  has a great chance of bieng next champions of cricket  .'
;

*
Methodology: Use PROC PRINT to print out the first twenty observations
from the sorted home runs temporary dataset created in the data prep file. 
Then compare winner by run.

Limitations: None

Possible Follow-up Steps: Use PROC MEANS to compute the home run average
for the data set and see just how far above this average the best win by runs 
are.
;


proc print 
        noobs 
        data = matches_analytic_file
    ;
    id 
        match_ID
    ;
    var 
        home win_by_runs
    ;
run;
title;
footnote;





title1
'Research Question: Who are the top 20 team with the highest score innings1_wickets average?'
;

title2
'Rationale: the  average is generally considered the premier stat for hitters, so the batters with the highest averages should have highst innings1_wickets  .'
;

footnote1
' there are a good amount of team with higest innings1_wickets under 1000 with highest innings1_wickets  averages.'
;

footnote2
' on oher hand , I think that these are outliers and do not represent the best winner since all but one of the teams shown with innings1_wickets above 1000 are significantly above 1000,.'
;

footnote3
'I would say that the teams  shown with low  innings1_wickets did not get many winnes .'
;

footnote4
'Overall, I think there is a correlation between innings1_wickets average and win_by_runs, but it is not as strong as the relationship with home wins'
;

*
Methodolody: Use PROC PRINT to print out the first twenty observations
from the win_by_run satting average temporary dataset created in the data prep
file. Then compare the salaries.

Limitations: None

Possible Follow-up Steps: Possibly find a correlation betweeninnings1
and win by runs by comparing for each
category using PROC SORT.
;

proc print 
        noobs 
        data= matches_analytic_file
    ;
    id 
        match_ID
    ;
    var 
        innings1 win_by_runs
    ;
run;
title;
footnote;




title1
'Research Question: Who are the top 20 teams win away ?'
;

title2
'Rationale: we can see how the team proform outside home.'
;

footnote1
'Sorting by this statistic shows a better correlation than between win and away .'
;

footnote2
'Very few teams among the top 20  by win far away from home'
;
*
Methodology: Use PROC PRINT to print out the first twenty observations
from the winner dataset created in the data prep file. 
Then compare winnig away.

Limitations: None

Possible Follow-up Steps: Compare the top twenty teams win ousaid home;

proc print 
        noobs 
        data=  matches_analytic_file (obs=20)
    ;
    id 
        match_ID
    ;
    var 
        winner away
    ;
run;
title;
footnote;
