*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;
*
[Dataset Name] T20 cricket mathces

[Experimental Units] Over 6000 matches since 2003 

[Number of Observations] 6,417

[Number of Features] 26

[Data Source] This data can be downloaded from Kaggle website.
https://www.kaggle.com/imrankhan17/t20matches/downloads/t20matches.zip



[Data Dictionary] https://www.kaggle.com/imrankhan17/t20matches/version/3

[Unique ID] The column "match_id" is a primary key
;

* setup environmental parameters;
%let inputDatasetURL =
https://github.com/stat6250/team-3_project1/blob/master/T20%20Matches.xlsx?raw=true
;

* load raw cricket matches dataset over the wire;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile "%sysfunc(getoption(work))/tempfile.xlsx";
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%loadDataIfNotAlreadyAvailable(
    matches_raw,
    &inputDatasetURL.,
    xlsx
)


* check raw dataset for duplicates with respect to its primary key;
proc sort
        nodupkey
        data=matches_raw
        dupout=matches_raw_dups
        out=_null_
    ;
    by
        match_id
    ;
run;


* build analytic dataset from cricket match dataset with the least number of 
columns and minimal cleaning/transformation needed to address research 
questions in corresponding data-analysis files;
data matches_analytic_file;
    retain
        home
        away
        winner
        win_by_runs
        innings1
    ;
    keep
        home
        away
        winner
        win_by_runs
        innings1
    ;
    set matches_raw;
run;

proc print data=matches_analytic_file (obs=5);
run;

* Use PROC FREQ and output a table with counts for winning matches of each team,
and use PROC SORT to sort from most wins to least wins by teams;
proc freq data=matches_analytic_file;
tables winner / out=sort_winner noprint;
run;
proc sort data=sort_winner;
    by descending count;
run;


* Use PROC FREQ nd output a table with counts for the times of each team that 
is being home/away, and use PROC SORT to sort from the most to least by teams,
and created new dataset for each;
proc freq data=matches_analytic_file;
    tables home / out=sort_home noprint;
run;

proc sort data=sort_home;
    by descending count;
run;


proc freq data= matches_analytic_file;
    tables away / out=sort_away noprint;
run;


proc sort data=sort_away;
    by descending count;
run;

data matches_raw_q2;
set matches_raw;
if winner=innings1 then inning1_winner=1 ;else inning1_winner=0;
if winner=innings2 then inning2_winner=1 ;else inning2_winner=0;
run;

/* Rename the three new created datasets, so that we have counts for each team
that wins the game; being home team in a match; and being away in a match as a 
variable. The idea is to change the original home/away/winner varaibles from
categorical to a frequency table-like;
*/
data new_sort_home(rename=(home=team count=home));
    set sort_home;
run;

data new_sort_away(rename=(away=team count=away));
    set sort_away;
run;

data new_sort_winner(rename=(winner=team count=winner));
    set sort_winner;
run;

* Merge 2 new datasets using PROC SQL, and defined a new variable called
total_match which stands for the number of matches a team had in 2017;

proc sql noprint;
     create table total_match as
     select L.team as home_team, L.home,
            R.team as away_team, R.away
     from new_sort_home L
     inner join new_sort_away R
     on L.team=R.team;
quit;

data home_away; set total_match;
    total_match = home + away;
run;
proc sort data=home_away;
    by descending total_match;
run;


* Merge the new created sort_winner dataset into the previous merged dataset
in order to create a new variable called winning_rate;
proc sql noprint;
     create table match_info as
     select L.*, R.*
     from home_away L
     join new_sort_winner R
     on L.home_team=R.team;
quit;
data question3; set match_info;
    winning_rate=winner / total_match;
run;
proc sort data=question3;
    by descending winning_rate;
run;
data question3_1;
    set question3;
    keep team percent winning_rate;
run;

* Use DATA Step to create a new dataset to produce a frequency table for each
team of winning a match as home;
data question2; set matches_analytic_file;
    if winner = home then
    home_win = 'Y';
    else 
    home_win="N";
    keep home away winner home_win;
run;



* 
Use PROC MEANS to compute the mean of win_by_run for winner, and output the 
results to a temporary dataset, and use PROC SORT to extract and sort just the 
means the temporary dateset.
;
proc means
        mean
        noprint
        data=matches_analytic_file
    ;
    class
        winner
    ;
    var
        win_by_runs
    ;
    output
        out=matches_analytic_file_temp
    ;
run;

proc sort
        data=matches_analytic_file_temp(where=(_STAT_="MEAN"))
    ;
    by
        descending win_by_runs
    ;
run;



