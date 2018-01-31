*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;
*
[Dataset Name] T20 cricket mathces

[Experimental Units] Over 6000 matches since 2003 

[Number of Observations] 6,417      
           
[Number of Features] 26

[Data Source] https://www.kaggle.com/imrankhan17/t20matches/downloads/t20matches.zip

This data can be downloaded from Kaggle website.

[Data Dictionary] https://www.kaggle.com/imrankhan17/t20matches/version/3

[Unique ID Schema] The column "match_id" is a primary key
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
    xls
)

* check raw dataset for duplicates with primary key;
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


* build analytic dataset from cricket match dataset with the least number of columns and
minimal cleaning/transformation needed to address research questions in
corresponding data-analysis files;
data matches_analytic_file;
    retain
        home
        away
        winner
        win_by_run
    ;
    keep
        home
        away
        winner
        win_by_run
    ;
    set matches_raw;
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
        win_by_run
    ;
    output
        out=matches_analytic_file_temp
    ;
run;

proc sort
        data=matches_analytic_file_temp(where=(_STAT_="MEAN"))
    ;
    by
        descending win_by_run
    ;
run;


*===================================================================================
Use PROC SORT and PROC SQL to create a subset table to include a new variable:      |
winning rate. which will be used as part of data analysis by LJ.                    |  
                                                                                    |
*===================================================================================
;
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


