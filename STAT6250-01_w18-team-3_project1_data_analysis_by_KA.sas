*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding free/reduced-price meals at CA public K-12 schools

Dataset Name: FRPM1516_analytic_file created in external file
STAT6250-02_s17-team-0_project1_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset FRPM1516_analytic_file;
%include '.\STAT6250-02_s17-team-0_project1_data_preparation.sas';



title1
'Research Question: What are the top twenty districts with the highest mean values of "Percent (%) Eligible FRPM (K-12)"?'
;

title2
'Rationale: This should help identify the school districts in the most need of outreach based upon child poverty levels.'
;

footnote1
'Based on the above output, 9 schools have 100% of their students eligible for free/reduced-price meals under the National School Lunch Program.'
;

footnote2
'Moreover, we can see that virtually all of the top 20 schools appear to be elementary schools, suggesting increasing early childhood poverty.'
;

footnote3
'Further analysis to look for geographic patterns is clearly warrented, given such high mean percentages of early childhood poverty.'
;
*
Methodology: Use PROC PRINT to print just the first twenty observations from
the temporary dataset created in the corresponding data-prep file.

Limitations: This methodology does not account for districts with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.

Possible Follow-up Steps: More carefully clean the values of the variable
Percent_Eligible_FRPM_K12 so that the means computed do not include any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;
proc print
        noobs
        data=FRPM1516_analytic_file_temp(obs=20)
    ;
    id
        District_Name
    ;
    var
        Percent_Eligible_FRPM_K12
    ;
run;
title;
footnote;



title1
'Research Question: How does the distribution of "Percent (%) Eligible FRPM (K-12)" for charter schools compare to that of non-charter schools?'
;

title2
'Rationale: This would help inform whether outreach based upon child poverty levels should be provided to charter schools.'
;

footnote1
'Based on the above output, the distribution of percentage eligible for free/reduced-price meals under the National School Lunch Program appears to be roughly the same for Charter and Non-charter Schools.'
;

footnote2
'However, Charter schools do appear to have slighly lower childhood poverty rates, overall, given the smaller first and second quartiles.'
;

footnote3
"In addition, more analysis is needed for the group with value 'N/A', which has a significanly reduced child poverty distribution."
;

*
Methodology: Compute five-number summaries by charter-school indicator variable

Limitations: This methodology does not account for schools with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.

Possible Follow-up Steps: More carefully clean the values of the variable
Percent_Eligible_FRPM_K12 so that the statistics computed do not include any
possible illegal values, and better handle missing data, e.g., by using a
previous year's data or a rolling average of previous years' data as a proxy.
;
proc means
        min q1 median q3 max
        data=FRPM1516_analytic_file
    ;
    class
        Charter_School
    ;
    var
        Percent_Eligible_FRPM_K12
    ;
run;
title;
footnote;



title1
'Research Question: Can "Enrollment (K-12)" be used to predict "Percent (%) Eligible FRPM (K-12)"?'
;

title2
'Rationale: This would help determine whether outreach based upon child poverty levels should be provided to smaller schools. E.g., if enrollment is highly correlated with FRPM rate, then only larger schools would tend to have high child poverty rates.'
;

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
