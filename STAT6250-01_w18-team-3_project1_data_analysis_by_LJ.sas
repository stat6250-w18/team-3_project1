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

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file that generates analytic dataset;
%include '.\STAT6250-01_w18-team-3_project1_data_preparation.sas';

title1 
'Research Question: Which 3 teams have the most winning games?';
    
title2 
'Rationale: Find out the teams good at winning games.';
    
footnote1
'Based on the above output, Chennai Super Ki, Mumbai Indians, Lancashire are the top 3 teams at winning games';

footnote2
"However when we look at the first two records, we can see there are abandoned matches and missing data which can cause some potential problems for further study.";

footnote3
"Before we do more advanced data analysis, we need to tackle the issues first by clearning the data, such as inspecting if there is any anomaly in the data";

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
proc print
        noobs
        data=sort_winner(obs=5);
run;
title;
footnote;

title1
'Research Question: What is the winning odds of home against away?';

title2  
'Rationale: Does home team have better performance?';

footnote1
"Based on the result, home teams are not at advantage winning against guest teams since they had fewer winning games";


*
Methodology: Use SET keyword to create a new data set and a new dummy variable
called home_win to indicate if home team wins the match. And then use PROC FREQ
to obtain the frequecies for home team won the match and home team lost the 
match.

Limitations: This methodology overlooked the missing data.

Possible Follow-up Steps: We need to omit missing values before analyzing;

proc freq data=question2;
    table home_win / nopercent nocum;
run;
title;    
footnote;


title1 
'Research Question: Research Question: Which team has the highest winning rate?';

title2 
'Rationale: Find out which team has the highest probability of winning.';
    
footnote1
"Based on the result, Peshawar Region has the highest winning rate.";

footnote2
"Winning rate equal to the number of won matches / total number of matches.";

footnote3
"Karachi Region Blues will have the second highest winning rate place, and Sialkot Stallions will be the third, and so on. The underlying problem is some of the high winning rate team only attended a few games, we might need do some deeper research for that.";

*
Methodology: Use PROC SQL to merge the data and created a new dataset with 
winning rate = winner / (home + away), where winner is the number of times a 
team won a match, home is number of the team attended a match as a home team, 
away is the number of a team attended a match as a guest team.

Limitations: This methodology overlooked the missing data and matches that 
are abandoned.

Possible Follow-up Steps: There are easier ways to get to the result, try 
to simplify the code;

proc print noobs
    data=question3_1(obs=5);
run;
title;    
footnote;




