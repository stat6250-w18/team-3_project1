*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;
/*
[Dataset Name] T20 cricket mathces

[Experimental Units] Over 6000 matches since 2003 

[Number of Observations] 6,417      
           
[Number of Features] 26

[Data Source] https://www.kaggle.com/imrankhan17/t20matches/downloads/t20matches.zip

This data can be downloaded from Kaggle website.

[Data Dictionary] https://www.kaggle.com/imrankhan17/t20matches/version/3

[Unique ID Schema] The column "match_id" is a primary key.

* setup environmental parameters;
%let inputDatasetURL =
https://github.com/stat6250/team-3_project1/blob/master/t20_matches.csv
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
            filename tempfile "%sysfunc(getoption(work))/tempfile.csv";
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
    csv
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
