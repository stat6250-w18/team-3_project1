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



