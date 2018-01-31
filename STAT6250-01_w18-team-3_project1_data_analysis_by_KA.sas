*******************************************************************************;
*This file uses the following analytic data set to address several research questions regarding T20 matches in the Sport of Cricket, specifically in the years 2003-2017.
Data set name: T20 matches created in external fileSTAT6250-01_team-3_project1_data_preparation.sas, which is assumed to being the same directory as this file.
See the file referenced above for data set properties.;
* environmental setup;
* set relative file import path to current directory;X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";
* load external file that generates analytic data set t20_matcehs;%include '.\STAT6250-01_team-3_project1_data_preparation.sas';

title1 
    'Research Question: What is the track record of teams(win/loose/draw) ?';
    
title2 
    'Rationale: Determine the ranking of team based on performance. ';
    
footnote1;

title1
    'Research Question: What are win/lose statistics for teams batting/bowling first ? ';
    
title2  
    'Rationale: This can help the team to decide to bat/bowl first depending on their track record and increase their chances of winning.';
    
footnote1;

title1 
    'Research Question: How many matches were improvised by D/L method (target runs is reduced due to weather and time factors)?';
     
title2 
    'Rationale: Use optimal venues and dates to fix matches so as to avoid sudden changes in weather resulting in implementation of D/L method ';
    
footnote1;
