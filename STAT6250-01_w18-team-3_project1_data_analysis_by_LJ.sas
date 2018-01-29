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

* load external file that generates analytic dataset;
%include '.\STAT6250-01_w18-team-3_project1_data_preparation.sas';

title1 
'Research Question: Which 5 teams have the most winning games?';
    
title2 
'Rationale: Find out the teams good at winning games.';
    
footnote1
'Based on the above output, Chennai Super Ki, Mumbai Indians, Lancashire, 
Hampshire, Warwickshire are the top 5 teams at winning games';

*
Methodology: Use PROC FREQ to list out the frequencies of each team's winning
matches. And created a temporary data file called sort_winner.

Limitations: This methodology only focused on the winning times of a team,
however, it overlooked the total number of matches a team attended. Also, 
this methodology does not account for potential data anomoly, such as missing
data, and abandoned games.

Possible Follow-up Steps: We need to look into the winning rate. 
That is the winning matches / total matches attended. More carefully clean the
values.
;

proc freq data=match;
tables winner / out=sort_winner;
run;

proc sort data=sort_winner;
    by descending count;
run;
title;
footnote;

title1
'Research Question: What is the winning odds of home against away?';

title2  
'Rationale: Does home team have better performance?';

footnote1
"Based on the result, home teams are not at advantage winning against 
guest teams";

*
Methodology: Use SET keyword to create a new data set and a new dummy variable
called home_win to indicate if home team wins the match. And then use PROC FREQ
to obtain the frequecies for home team won the match and home team lost the 
match.

Limitations: This methodology overlooked the missing data.

Possible Follow-up Steps: We need to omit missing values before analyzing;

data question2; set match;
    if winner = home then
    home_win = 'Y';
    else 
    home_win="N";
    keep home away winner home_win;
run;
proc freq data=question2;
    table home_win / nopercent nocum;
run;
title;    
footnote;


title1 
'Research Question: Research Question: Which team has the highest winning rate? 
that is number of won matches / total number of matches.';

title2 
'Rationale: Find out which team has the highest probability of winning.';
    
footnote1
"Based on the result, Peshawar Region, Zarai Taraqiati, Lahore Lions are the 
top 3 teams with highest winning rate.";

*
Methodology: Use PROC SQL to merge the data and created a new dataset with 
winning rate = winner / (home + away), where winner is the number of times a 
team won a match, home is number of the team attended a match as a home team, 
away is the number of a team attended a match as a guest team.

Limitations: This methodology overlooked the missing data and matches that 
are abandoned.

Possible Follow-up Steps: There are easier ways to get to the result, try 
to simplify the code;

*sort by winner;
proc freq data=match;
tables winner / out=sort_winner;
run;

proc sort data=sort_winner;
    by descending count;
run;

*sort by home;
proc freq data=match;
    tables home / out=sort_home;
run;

proc sort data=sort_home;
    by descending count;
run;

*sort by away;
proc freq data=match;
    tables away / out=sort_away;
run;


proc sort data=sort_away;
    by descending count;
run;

*==========================================================;
data new_sort_home(rename=(home=team count=home));
    set sort_home;
run;

data new_sort_away(rename=(away=team count=away));
    set sort_away;
run;

data new_sort_winner(rename=(winner=team count=winner));
    set sort_winner;
run;

* merge home table and away table;
proc sql;
     create table total_match as
     select     L.*, R.*
     from new_sort_home L
     inner join  new_sort_away R
     on L.team=R.team;
quit;

data home_away; set total_match;
    total_match = home + away;
run;
proc sort data=home_away;
    by descending total_match;
run;

* merge the 3rd table (winner) into the merged one from home and away;
proc sql;
     create table match_info as
     select     L.*, R.*
     from home_away L
     join  new_sort_winner R
     on L.team=R.team;
quit;
data question3; set match_info;
    winning_rate=winner / total_match;
run;
proc sort data=question3;
    by descending winning_rate;
run;
title;    
footnote;
