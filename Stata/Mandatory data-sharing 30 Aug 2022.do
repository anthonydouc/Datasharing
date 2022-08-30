ALSO NEED TO FIX UP THE YEAR SUBMITTED ISSUE

***********************************************************************************************************************************************************************************************
* These commands reproduce the results reported in 'The Significance of Data-Sharing Policy' by Askarov et al. Journal of the European Economic Association.  
* Commands were written with Stata version 16.
* To run these commands install: (1) did_imputation and (2) event_plot. Also, update: (1) reghdfe and (2) ftools. 
* Commands in Part A are used for the main part of the paper and commands in Part B for the Online Supplement.
* For Tables 2, 3, 4 and 5 of the main paper use the file: 'Mandatory data-sharing 30 Aug 2022.dta'. These data are also used for tables S1, S2, S3, S4 (Columns (1) & (2)) of the Online Supplement.
* For Table S4, Column (3) of the Online Supplement use the data file: 'Using only top 31.dta'
* For Table S4, Column (4) of the Online Supplement use the data file: 'With outliers included 30 Aug.dta' 
* For Table S10 of the Online Supplement use the data file: 'Stacked data 30 Aug.dta'
* For Table S11 of the Online Supplement use the data file: 'Analysis of shares July 2022.dta'
* Please also read the 'ReadMe' file.

************************************************************************************************************************************************************************************************************************************************************************************************
*** PART A. RESULTS REPORTED IN MAIN ARTICLE
************************************************************************************************************************************************************************************************************************************************************************************************
*** use the file: 'Mandatory data-sharing 30 Aug 2022.dta'
*** Encode variables
encode journal, gen(Njournal)
encode filename, gen(Nresearcharea)
rename yearpublished YEAR
*** The variable EVENT identifies all leading economics journals with mandated data-sharing. 
gen EVENT = 0
replace EVENT = 1 if journal == "American economic journal: applied economics"
replace EVENT = 1 if journal == "American economic journal: macroeconomics" 
replace EVENT = 1 if journal == "American economic journal: economic policy"
replace EVENT = 1 if journal == "American economic journal: microeconomics" 
replace EVENT = 1 if journal == "Econometrica" 
replace EVENT = 1 if journal == "Journal of business and economic statistics" 
replace EVENT = 1 if journal == "Journal of development economics"
replace EVENT = 1 if journal == "Journal of economic growth"
replace EVENT = 1 if journal == "Journal of human resources" 
replace EVENT = 1 if journal == "Journal of labor economics" 
replace EVENT = 1 if journal == "Journal of money credit and banking" 
replace EVENT = 1 if journal == "Journal of political economy" 
replace EVENT = 1 if journal == "Journal of the european economic association" 
replace EVENT = 1 if journal == "The american economic review" 
replace EVENT = 1 if journal == "The economic journal" 
replace EVENT = 1 if journal == "The quarterly journal of economics" 
replace EVENT = 1 if journal == "The review of economic studies" 
replace EVENT = 1 if journal == "The review of economics and statistics" 
replace EVENT = 1 if journal == "European economic review" 
*** The variable 'INTERVENTION' identifies the period during which any leading journal mandated data-sharing. 
** The variable 'yearsubmitted' is the year an article was submitted for review where this information is available OR the year published lagged two years otherwise (the sample median difference between year published and year submitted).
gen INTERVENTION = 0
replace INTERVENTION = 1 if journal == "American economic journal: applied economics" & yearsubmitted >=2009
replace INTERVENTION = 1 if journal == "American economic journal: macroeconomics" & yearsubmitted >=2009
replace INTERVENTION = 1 if journal == "American economic journal: economic policy" & yearsubmitted >=2009
replace INTERVENTION = 1 if journal == "American economic journal: microeconomics" & yearsubmitted >=2009
replace INTERVENTION = 1 if journal == "Journal of human resources" & yearsubmitted >=1990
replace INTERVENTION = 1 if journal == "Journal of money credit and banking" & yearsubmitted >=1998
replace INTERVENTION = 1 if journal == "Econometrica" & yearsubmitted >=2004
replace INTERVENTION = 1 if journal == "The american economic review" & yearsubmitted >=2005
replace INTERVENTION = 1 if journal == "Journal of political economy" & yearsubmitted >=2006
replace INTERVENTION = 1 if journal == "Journal of labor economics" & yearsubmitted >=2009
replace INTERVENTION = 1 if journal == "The review of economic studies" & yearsubmitted >=2010
replace INTERVENTION = 1 if journal == "The review of economics and statistics" & yearsubmitted >=2010
replace INTERVENTION = 1 if journal == "Journal of the european economic association" & yearsubmitted >=2011
replace INTERVENTION = 1 if journal == "Journal of business and economic statistics" & yearsubmitted >=2011
replace INTERVENTION = 1 if journal == "The economic journal" & yearsubmitted >=2012
replace INTERVENTION = 1 if journal == "European economic review"  & yearsubmitted >=2012
replace INTERVENTION = 1 if journal == "Journal of economic growth" & yearsubmitted >=2013
replace INTERVENTION = 1 if journal == "Journal of development economics" & yearsubmitted >=2014
replace INTERVENTION = 1 if journal == "The quarterly journal of economics" & yearsubmitted >=2016
*** The variable 'YEARintervention' identifies year data-sharing mandated.
gen     YEARintervention = 0
replace YEARintervention = 2009 if journal == "American economic journal: applied economics" 
replace YEARintervention = 2009 if journal == "American economic journal: economic policy" 
replace YEARintervention = 2009 if journal == "American economic journal: macroeconomics" 
replace YEARintervention = 2009 if journal == "American economic journal: microeconomics" 
replace YEARintervention = 2004 if journal == "Econometrica" 
replace YEARintervention = 2012 if journal == "European economic review"  
replace YEARintervention = 2011 if journal == "Journal of business and economic statistics"  
replace YEARintervention = 2014 if journal == "Journal of development economics" 
replace YEARintervention = 2013 if journal == "Journal of economic growth"
replace YEARintervention = 1990 if journal == "Journal of human resources"
replace YEARintervention = 2009 if journal == "Journal of labor economics"
replace YEARintervention = 1998 if journal == "Journal of money credit and banking"
replace YEARintervention = 2006 if journal == "Journal of political economy"
replace YEARintervention = 2011 if journal == "Journal of the european economic association"
replace YEARintervention = 2005 if journal == "The american economic review" 
replace YEARintervention = 2012 if journal == "The economic journal" 
replace YEARintervention = 2016 if journal == "The quarterly journal of economics" 
replace YEARintervention = 2010 if journal == "The review of economic studies" 
replace YEARintervention = 2010 if journal == "The review of economics and statistics" 
*** The variable 'PUNTEY' is the unit-specific date of treatment used in the imputation method. 
gen     PUNTEY = 0
replace PUNTEY = YEARintervention
replace PUNTEY = . if EVENT == 0
*** create leadlag variable; the difference between year submitted and year data-sharing was mandated.
gen leadlagsub = yearsubmitted - YEARintervention
*** The variable 'RETAIN' identifies the sample up to 4 years post data-sharing for data-sharing journals and all control (non-adopting or non-treatment) journals. Horizons beyond t = 4 are affected by very large journal composition differences. 
gen     RETAIN = 0
replace RETAIN = 1 if journal == "The american economic review" & yearsubmitted <=2009 
replace RETAIN = 1 if journal == "Journal of political economy" & yearsubmitted <=2010 
replace RETAIN = 1 if journal == "The quarterly journal of economics" & yearsubmitted <=2020 
replace RETAIN = 1 if journal == "The review of economic studies" & yearsubmitted <=2014 
replace RETAIN = 1 if journal == "Econometrica" &  yearsubmitted <=2008 
replace RETAIN = 1 if journal == "The review of economics and statistics" & yearsubmitted <=2014
replace RETAIN = 1 if journal == "European economic review" &  yearsubmitted <=2016 
replace RETAIN = 1 if journal == "The economic journal" &  yearsubmitted <=2016 
replace RETAIN = 1 if journal == "Journal of the european economic association" & yearsubmitted <= 2015 
replace RETAIN = 1 if journal == "Journal of development economics" &  yearsubmitted <=2018 
replace RETAIN = 1 if journal == "Journal of money credit and banking" &  yearsubmitted <=2002 
replace RETAIN = 1 if journal == "Journal of human resources" &  yearsubmitted <=1994 
replace RETAIN = 1 if journal == "Journal of labor economics" &  yearsubmitted <=2013
replace RETAIN = 1 if EVENT   == 0
replace RETAIN = 1 if journal == "Journal of business and economic statistics"
replace RETAIN = 1 if journal == "Journal of economic growth"
*** The variable 'Excludegroup' identifies 'treated' journals that are excluded from the analysis (the American Economic Journals that have always had mandated data sharing) AND journals with fewer than 100 observations. 
gen Excludegroup = 0
replace Excludegroup = 1 if journal == "American economic journal: applied economics" 
replace Excludegroup = 1 if journal == "American economic journal: macroeconomics" 
replace Excludegroup = 1 if journal == "American economic journal: economic policy" 
replace Excludegroup = 1 if journal == "Rand journal of economics"
replace Excludegroup = 1 if journal == "Games and economic behavior"
replace Excludegroup = 1 if journal == "Journal of economic theory"
replace Excludegroup = 1 if journal == "International economic review"

*** TABLE 2, Mandatory data-sharing, Difference-in-Differences, BJS DD imputation estimator
** Panel A.	Four-year post-data-sharing window no anticipation of policy
* Column (1) No fixed effects or covariates
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(.) autosample cluster(studyid) saveweights maxit(1000)
rename __* Baseweight4w
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(.) autosample cluster(studyid) maxit(1000) loadweights( Baseweight4w ) pretrend(7)   
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(.) autosample cluster(studyid) maxit(1000) loadweights( Baseweight4w ) pretrend(7)
ereturn list
* Column(2) Plus journal and time fixed effects 
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted) autosample cluster(studyid) saveweights maxit(1000)
rename __* TWFEweight4w
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted) autosample cluster(studyid) maxit(1000) loadweights( TWFEweight4w ) pretrend(7)   
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted) autosample cluster(studyid) maxit(1000) loadweights( TWFEweight4w) pretrend(7)    
ereturn list
* Column(3) Plus field of research effects 
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) autosample cluster(studyid) saveweights maxit(1000)
rename __* TWFERareaweight4w
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) autosample cluster(studyid) maxit(1000) loadweights( TWFERareaweight4w )  pretrend(7)  
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) autosample cluster(studyid) maxit(1000) loadweights(TWFERareaweight4w) pretrend(7)   
ereturn list
* Column(4) Plus covariates
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) autosample cluster(studyid) saveweights maxit(1000)
rename __* TWFERareacovaweight4w
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) autosample cluster(studyid) maxit(1000) loadweights( TWFERareacovaweight4w) pretrend(7)   
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) autosample cluster(studyid) maxit(1000) loadweights( TWFERareacovaweight4w) pretrend(7)   
ereturn list
* Step 1 covariates (reported in the Online Supplement). This analysis uses only non-treated observations. Note that we initially used these commands as did_imputation did not at that time report covariates. The latest version of the program reports results for covariates and hence Step 1 no longer needs to be carried out separately. 
reg tstat    numberofauthors temporal_rank EXPERIMENT mixed i.Njournal i.yearsubmitted i.Nresearcharea if Excludegroup !=1 & RETAIN ==1 & INTERVENTION !=1,  cluster(studyid) 
reg ex_sig19 numberofauthors temporal_rank EXPERIMENT mixed i.Njournal i.yearsubmitted i.Nresearcharea if Excludegroup !=1 & RETAIN ==1 & INTERVENTION !=1,  cluster(studyid) 
* Column(5) Plus journal specific trends
did_imputation tstat Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* TWFERunittrendaweight4w
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( TWFERunittrendaweight4w)  pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( TWFERunittrendaweight4w)  pretrend(7)
ereturn list
* Step 1 covariates (reported in the Online Supplement). This analysis uses only non-treated observations. Note that we initially used these commands as did_imputation did not report covariates. Latest version does report results for covariates and hence Step 1 no longer needs to be carried out separately.
reg tstat     numberofauthors temporal_rank EXPERIMENT mixed c.YEAR##i.Njournal i.yearsubmitted i.Nresearcharea if Excludegroup !=1 & RETAIN ==1 & INTERVENTION !=1,  cluster(studyid) 
reg ex_sig19  numberofauthors temporal_rank EXPERIMENT mixed c.YEAR##i.Njournal i.yearsubmitted i.Nresearcharea if Excludegroup !=1 & RETAIN ==1 & INTERVENTION !=1,  cluster(studyid) 

*** TABLE 2, Panel B.	Allowing for anticipation effects, four-year post-data-sharing window
* Column (1) No fixed effects or covariates
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1,  fe(.) autosample cluster(studyid) saveweights maxit(1000) shift(1)
rename __* Ant4*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(.) autosample cluster(studyid) maxit(1000) loadweights( Ant4w) shift(1) pretrend(7)  
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(.) autosample cluster(studyid) maxit(1000) loadweights( Ant4w) shift(1) pretrend(7)   
ereturn list
* Column(2) Plus journal and time fixed effects 
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted) autosample cluster(studyid) saveweights maxit(1000) shift(1)
rename __* TWFEweightAnt4*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted) autosample cluster(studyid) maxit(1000) loadweights(TWFEweightAnt4w) shift(1) pretrend(7)     
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted) autosample cluster(studyid) maxit(1000) loadweights(TWFEweightAnt4w) shift(1) pretrend(7)     
ereturn list
* Column(3) Plus field of research effects 
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) autosample cluster(studyid) saveweights maxit(1000) shift(1)
rename __* TWFERareaweightAnt*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) autosample cluster(studyid) maxit(1000) loadweights(TWFERareaweightAntw) shift(1) pretrend(7)        
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) autosample cluster(studyid) maxit(1000) loadweights(TWFERareaweightAntw) shift(1) pretrend(7)        
ereturn list
* Column(4) Plus covariates
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank  EXPERIMENT mixed) autosample cluster(studyid) saveweights maxit(1000) shift(1)
rename __* TWFERareacovaweightAnt*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank  EXPERIMENT mixed) autosample cluster(studyid) maxit(1000) loadweights( TWFERareacovaweightAntw ) shift(1) pretrend(7)          
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank  EXPERIMENT mixed) autosample cluster(studyid) maxit(1000) loadweights( TWFERareacovaweightAntw ) shift(1) pretrend(7)        
ereturn list
* Step 1 covariates (allowing for one year anticipation). These results are reported in the Online Supplement.
gen INTERVENTION1 = 0
replace INTERVENTION1 = 1 if journal == "American economic journal: applied economics" & yearsubmitted >=2008
replace INTERVENTION1 = 1 if journal == "American economic journal: macroeconomics" & yearsubmitted >=2008
replace INTERVENTION1 = 1 if journal == "American economic journal: economic policy" & yearsubmitted >=2008
replace INTERVENTION1 = 1 if journal == "American economic journal: microeconomics" & yearsubmitted >=2008
replace INTERVENTION1 = 1 if journal == "Journal of human resources" & yearsubmitted >=1989
replace INTERVENTION1 = 1 if journal == "Journal of money credit and banking" & yearsubmitted >=1997
replace INTERVENTION1 = 1 if journal == "Econometrica" & yearsubmitted >=2003
replace INTERVENTION1 = 1 if journal == "The american economic review" & yearsubmitted >=2004
replace INTERVENTION1 = 1 if journal == "Journal of political economy" & yearsubmitted >=2005
replace INTERVENTION1 = 1 if journal == "Journal of labor economics" & yearsubmitted >=2008
replace INTERVENTION1 = 1 if journal == "The review of economic studies" & yearsubmitted >=2009
replace INTERVENTION1 = 1 if journal == "The review of economics and statistics" & yearsubmitted >=2009
replace INTERVENTION1 = 1 if journal == "Journal of the european economic association" & yearsubmitted >=2010
replace INTERVENTION1 = 1 if journal == "Journal of business and economic statistics" & yearsubmitted >=2010
replace INTERVENTION1 = 1 if journal == "The economic journal" & yearsubmitted >=2011
replace INTERVENTION1 = 1 if journal == "European economic review"  & yearsubmitted >=2011
replace INTERVENTION1 = 1 if journal == "Journal of economic growth" & yearsubmitted >=2012
replace INTERVENTION1 = 1 if journal == "Journal of development economics" & yearsubmitted >=2013
replace INTERVENTION1 = 1 if journal == "The quarterly journal of economics" & yearsubmitted >=2015
reg tstat numberofauthors temporal_rank EXPERIMENT mixed i.Njournal i.yearsubmitted i.Nresearcharea if Excludegroup !=1 & RETAIN ==1 & INTERVENTION1 !=1,  cluster(studyid) 
reg ex_sig196  numberofauthors temporal_rank EXPERIMENT mixed i.Njournal i.yearsubmitted i.Nresearcharea if Excludegroup !=1 & RETAIN ==1 & INTERVENTION1 !=1,  cluster(studyid) 
* Column(5) Plus journal specific trends
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1,  fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed ) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001) shift(1)
rename __* unittrendaweightAnt*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( unittrendaweightAntw) shift(1) pretrend(7)        
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( unittrendaweightAntw) shift(1) pretrend(7)        
ereturn list
* Step 1 covariates. These results are reported in the Online Supplement.
reg tstat     numberofauthors temporal_rank EXPERIMENT mixed c.YEAR##i.Njournal i.yearsubmitted i.Nresearcharea if Excludegroup !=1 & RETAIN ==1 & INTERVENTION1 !=1,  cluster(studyid) 
reg ex_sig196 numberofauthors temporal_rank EXPERIMENT mixed c.YEAR##i.Njournal i.yearsubmitted i.Nresearcharea if Excludegroup !=1 & RETAIN ==1 & INTERVENTION1 !=1,  cluster(studyid) 

*** TABLE 3 Sub-sample robustness checks
* Column (1) top 5 journals
*** The variable 'Excludegroup5' identifies Top 5 'treated' journals only, i.e. excludes the non-top 5 & Tier A field data-sharing journals. 
gen     Excludegroup5 = 0
replace Excludegroup5 = 1 if journal == "American economic journal: applied economics" 
replace Excludegroup5 = 1 if journal == "American economic journal: macroeconomics" 
replace Excludegroup5 = 1 if journal == "American economic journal: economic policy" 
replace Excludegroup5 = 1 if journal == "Rand journal of economics"
replace Excludegroup5 = 1 if journal == "Games and economic behavior"
replace Excludegroup5 = 1 if journal == "Journal of economic theory"
replace Excludegroup5 = 1 if journal == "International economic review"
replace Excludegroup5 = 1 if journal == "Journal of development economics"
replace Excludegroup5 = 1 if journal == "Journal of money credit and banking" 
replace Excludegroup5 = 1 if journal == "Journal of human resources" 
replace Excludegroup5 = 1 if journal == "Journal of labor economics" 
replace Excludegroup5 = 1 if journal == "Journal of the european economic association" 
replace Excludegroup5 = 1 if journal == "The economic journal" 
replace Excludegroup5 = 1 if journal == "The review of economics and statistics" 
replace Excludegroup5 = 1 if journal == "European economic review" 
did_imputation tstat     Njournal yearsubmitted PUNTEY if RETAIN ==1 & Excludegroup5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed)  unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* Top54*
did_imputation tstat     Njournal yearsubmitted PUNTEY if RETAIN ==1 & Excludegroup5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights(Top54w) pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if RETAIN ==1 & Excludegroup5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors  temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights(Top54w) pretrend(7)
ereturn list
*** Column (2) non-top 5 journals
*** The variable 'Excludegroupnon5' identifies non-Top 5 'treated' journals only, i.e. excludes the top 5 data-sharing journals. 
gen Excludegroupnon5 = 0
replace Excludegroupnon5 = 1 if journal == "American economic journal: applied economics" 
replace Excludegroupnon5 = 1 if journal == "American economic journal: macroeconomics" 
replace Excludegroupnon5 = 1 if journal == "American economic journal: economic policy" 
replace Excludegroupnon5 = 1 if journal == "Rand journal of economics"
replace Excludegroupnon5 = 1 if journal == "Games and economic behavior"
replace Excludegroupnon5 = 1 if journal == "Journal of economic theory"
replace Excludegroupnon5 = 1 if journal == "International economic review"
replace Excludegroupnon5 = 1 if journal == "Econometrica" 
replace Excludegroupnon5 = 1 if journal == "The american economic review" 
replace Excludegroupnon5 = 1 if journal == "The quarterly journal of economics" 
replace Excludegroupnon5 = 1 if journal == "The review of economic studies" 
replace Excludegroupnon5 = 1 if journal == "Journal of political economy" 
did_imputation tstat     Njournal yearsubmitted PUNTEY if RETAIN ==1 & Excludegroupnon5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* NonTop54*
did_imputation tstat     Njournal yearsubmitted PUNTEY if RETAIN ==1 & Excludegroupnon5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( NonTop54w) pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if RETAIN ==1 & Excludegroupnon5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( NonTop54w) pretrend(7)
ereturn list
*** Column (3) without JHR & JMCB (excludes Journal of Human Resources and the Journal of Money, Credit and Banking)
gen WithoutJHR = 0
replace WithoutJHR = 1 if journal == "Journal of human resources" 
replace WithoutJHR = 1 if journal == "Journal of money credit and banking"
did_imputation tstat Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & WithoutJHR !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001) 
rename __* noJHR4*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & WithoutJHR !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors  temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( noJHR4w) pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & WithoutJHR !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors  temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( noJHR4w) pretrend(7)
ereturn list
*** Column (4) Post-1999 (includes only data published from year 2000 onwards)
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & YEAR >=2000, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* y20004*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & YEAR >=2000, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( y20004w) pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & YEAR >=2000, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights(y20004w)pretrend(7)
ereturn list
** Column(5) Pre- & post- research areas 
* The variable WITHPREANDPOST identifies the 89 research areas with pre- and post-data-sharing observations.
gen WITHPREANDPOST = 0
replace WITHPREANDPOST = 1 if filename == "income and democracy.xlsx"
replace WITHPREANDPOST = 1 if filename == "creditor protection private credit.xlsx"
replace WITHPREANDPOST = 1 if filename == "Copy of Discrimination in the laboratory_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Tuition and demand for higher education.xlsx"
replace WITHPREANDPOST = 1 if filename == "Gender differences in investment.xlsx"
replace WITHPREANDPOST = 1 if filename == "French law PC.xlsx"
replace WITHPREANDPOST = 1 if filename == "earthquakes and house prices.xlsx"
replace WITHPREANDPOST = 1 if filename == "Copy of sheep skin effect_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Financial openness PC.xlsx"
replace WITHPREANDPOST = 1 if filename == "non-US Aid Allocations April 26 2019 - Human Rights.xlsx"
replace WITHPREANDPOST = 1 if filename == "Inflation PC.xlsx"
replace WITHPREANDPOST = 1 if filename == "Child Penalty.xlsx"
replace WITHPREANDPOST = 1 if filename == "Elasticity of taxable income.xlsx"
replace WITHPREANDPOST = 1 if filename == "Gender Differences in Risk Attitudes.xlsx"
replace WITHPREANDPOST = 1 if filename == "Copy of Stake size in games_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Discrimination in hiring.xlsx"
replace WITHPREANDPOST = 1 if filename == "production of knowledge.xlsx"
replace WITHPREANDPOST = 1 if filename == "Copy of RD and productivity in OECD firms and industries_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Effect of warming on agriculture.xlsx"
replace WITHPREANDPOST = 1 if filename == "Effectiveness of fiscal incentives for innovation.xlsx"
replace WITHPREANDPOST = 1 if filename == "Inflation targetting and inflation volatility.xlsx"
replace WITHPREANDPOST = 1 if filename == "Copy of Data_Cazals-Mandon POLITICAL BUDGET CYCLES_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Klomp and  de Haan 2010 Inflation and central bank independence.xlsx"
replace WITHPREANDPOST = 1 if filename == "Observability affect prosociality_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "border effects of trade.xlsx"
replace WITHPREANDPOST = 1 if filename == "Technological innovation and employment.xlsx"
replace WITHPREANDPOST = 1 if filename == "Monopsony in Labour Markets.xlsx"
replace WITHPREANDPOST = 1 if filename == "Personality social value orientation.xlsx"
replace WITHPREANDPOST = 1 if filename == "Labor Market Policies_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Balliet et al. Gender Differences in Cooperation.xlsx"
replace WITHPREANDPOST = 1 if filename == "Copy of Disinflation and Central Bank Independence_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Habit Formation in Consumption authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Publication Bias and the Cross-Section of Stock Returns.xlsx"
replace WITHPREANDPOST = 1 if filename == "12. Natural disasters authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Personality trust propensity.xlsx"
replace WITHPREANDPOST = 1 if filename == "multilateral Aid Allocations - democracy.xlsx"
replace WITHPREANDPOST = 1 if filename == "Black test score gap.xlsx"
replace WITHPREANDPOST = 1 if filename == "Democracy and Growth 2019.xlsx"
replace WITHPREANDPOST = 1 if filename == "31. Valickova, Havranek, Horvath  Financial Development and Economic Growth authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "38. Fleury and Giles intergenerational transmission of education journal.xlsx"
replace WITHPREANDPOST = 1 if filename == "Belman-Wolfson Minimum wage encoded.xlsx"
replace WITHPREANDPOST = 1 if filename == "Chetty et al Does indivisible labor explain the difference between micro and macro elasticitiesAuthor.xlsx"
replace WITHPREANDPOST = 1 if filename == "Cognitive ability and risk aversion_With Authors domain of gains.xlsx"
replace WITHPREANDPOST = 1 if filename == "Copy of Chletsos and Giotis Minimum Wage World Data.xlsx"
replace WITHPREANDPOST = 1 if filename == "Copy of Discount Rate_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Copy of Natural Resources and Conflict_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Copy of Social Cost of Carbon.xlsx"
replace WITHPREANDPOST = 1 if filename == "Copy of government spending and inequality_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Copy of govt education spending and growth_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Improving Learning Outcomes in South Asia Composite Score.xlsx"
replace WITHPREANDPOST = 1 if filename == "Improving Learning Outcomes in South Asia Maths Score.xlsx"
replace WITHPREANDPOST = 1 if filename == "Improving Learning Outcomes in South Asia Native Language.xlsx"
replace WITHPREANDPOST = 1 if filename == "Conditional Cash Transfers and Education.xlsx"
replace WITHPREANDPOST = 1 if filename == "Contact Hypothesis Re-evaluated_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Dishonest behavior.xlsx"
replace WITHPREANDPOST = 1 if filename == "Distribution of school spending with authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Do Some Countries Discriminate More than Others.xlsx"
replace WITHPREANDPOST = 1 if filename == "FINANCIAL EDUCATION AFFECTS FINANCIAL KNOWLEDGE.xlsx"
replace WITHPREANDPOST = 1 if filename == "Frisch elasticity.xlsx"
replace WITHPREANDPOST = 1 if filename == "George C and George M Taylor Rule Output gap.xlsx"
replace WITHPREANDPOST = 1 if filename == "Havranek Intertemporal Substitution authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Havranek Rose effect authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Marriage wage premium.xlsx"
replace WITHPREANDPOST = 1 if filename == "MetaMin May 2012 - Copy.xlsx"
replace WITHPREANDPOST = 1 if filename == "Performance Management_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Personality social value orientation.xlsx"
replace WITHPREANDPOST = 1 if filename == "Personality trust propensity.xlsx"
replace WITHPREANDPOST = 1 if filename == "Present bias.xlsx"
replace WITHPREANDPOST = 1 if filename == "Punishment and Cooperation.xlsx"
replace WITHPREANDPOST = 1 if filename == "Skilled and Unskilled Labor.xlsx"
replace WITHPREANDPOST = 1 if filename == "Ugur 2019 RD Spillovers and Productivity.xlsx"
replace WITHPREANDPOST = 1 if filename == "US Aid Allocations April 26 2019.xlsx"
replace WITHPREANDPOST = 1 if filename == "Reciprocal trade agreements.xlsx"
replace WITHPREANDPOST = 1 if filename == "Rusnak Havranek Horvath 2013 How to Solve the Price Puzzle 12 months.xlsx"
replace WITHPREANDPOST = 1 if filename == "Rusnak Havranek Horvath 2013 How to Solve the Price Puzzle 18 months.xlsx" 
replace WITHPREANDPOST = 1 if filename == "Rusnak Havranek Horvath 2013 How to Solve the Price Puzzle 3 months.xlsx" 
replace WITHPREANDPOST = 1 if filename == "Rusnak Havranek Horvath 2013 How to Solve the Price Puzzle 6 months.xlsx" 
replace WITHPREANDPOST = 1 if filename == "Rusnak Havranek Horvath 2013 How to Solve the Price Puzzle 36 months.xlsx"
replace WITHPREANDPOST = 1 if filename == "wage impact of teachers unions.xlsx"
replace WITHPREANDPOST = 1 if filename == "Volatility Growth.xlsx"
replace WITHPREANDPOST = 1 if filename == "Shedding light on the shadows of informality.xlsx"
replace WITHPREANDPOST = 1 if filename == "sensitivity of consumption to income.xlsx"
replace WITHPREANDPOST = 1 if filename == "Post-privatisation ownership and performance_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "non-US Aid Allocations April 26 2019 - democracy.xlsx"
replace WITHPREANDPOST = 1 if filename == "forward premium puzzle.xlsx"
replace WITHPREANDPOST = 1 if filename == "Copy of paradox of plenty direct effects_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Copy of Master sheet 2019-22-01 Immigration and House Price Meta Data_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Copy of International tax avoidance_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "Copy of ethnic discrimination in housing markets_With Authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "7. MA_Union&Satisfaction_PL authors.xlsx"
replace WITHPREANDPOST = 1 if filename == "12. Natural disasters authors - Indirect.xlsx"
replace WITHPREANDPOST = 1 if filename == "06. Santeramo & Shabnam 2015 The income-elasticity of calories journals.xlsx"
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & WITHPREANDPOST ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* unittrendaweightPrePost*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & WITHPREANDPOST ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( unittrendaweightPrePostw) pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & WITHPREANDPOST ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( unittrendaweightPrePostw) pretrend(7)
ereturn list
*** Column (6) Balanced panel
** This defines panel for first 3 years post data-sharing, ie. these four journals observed in each of the next 3 years (European economic review; Journal of development economics; Journal of labor economics; The american economic review)
gen PostPanel = 0
replace PostPanel = 1 if journal == "Econometrica" 
replace PostPanel = 1 if journal == "Journal of business and economic statistics" 
replace PostPanel = 1 if journal == "Journal of economic growth"
replace PostPanel = 1 if journal == "Journal of human resources" 
replace PostPanel = 1 if journal == "Journal of money credit and banking" 
replace PostPanel = 1 if journal == "Journal of political economy" 
replace PostPanel = 1 if journal == "Journal of the european economic association" 
replace PostPanel = 1 if journal == "The economic journal" 
replace PostPanel = 1 if journal == "The quarterly journal of economics" 
replace PostPanel = 1 if journal == "The review of economic studies" 
replace PostPanel = 1 if journal == "The review of economics and statistics" 
did_imputation tstat Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & PostPanel !=1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* PostPanel4*
did_imputation tstat   Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & PostPanel !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( PostPanel4w) pretrend(7)
ereturn list
did_imputation ex_sig196  Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & PostPanel !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( PostPanel4w) pretrend(7)
ereturn list
*** Column (7) Macroeconomic research
** The variable MACRO = 1 if a research area involves a macroeconomics topic/issue.
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & MACRO ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* Macro4*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & MACRO ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( Macro4w) pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & MACRO ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Macro4w) pretrend(7)
ereturn list

*** TABLE 4 Timing, anticipation and lagged enforcement robustness checks
* Column (1) Known submission date
* 'submissiondate' is binary variable =1 if submission year is known (reported in published paper) and 0 otherwise. 
did_imputation tstat 	 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & SubmissionKnown ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* Knowsubmission*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & SubmissionKnown ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( Knowsubmissionw)  pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & SubmissionKnown ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Knowsubmissionw)  pretrend(7)
ereturn list
* Column (2) Year published dating
did_imputation tstat     Njournal YEAR PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal YEAR Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* YEAR4*
did_imputation tstat     Njournal YEAR PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal YEAR Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( YEAR4w) pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal YEAR PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal YEAR Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( YEAR4w) pretrend(7)
ereturn list
** Resaults reported in footnote 41.
did_imputation tstat     Njournal YEAR PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal YEAR Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001) shift(1)
rename __* YEAR4ant*
did_imputation tstat     Njournal YEAR PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal YEAR Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( YEAR4antw) pretrend(7) shift(1)
ereturn list
did_imputation ex_sig196 Njournal YEAR PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal YEAR Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( YEAR4antw) pretrend(7) shift(1)
ereturn list
* Column (3) Anticipation in top 5 only.
*** Anticipation in Top 5 
*** create new unit-specific date of treatment variable that assumes 'treatment' one year prior to mandated data-sharing
gen YEARintervention3 = 0
replace YEARintervention3 = 2009 if journal == "American economic journal: applied economics" 
replace YEARintervention3 = 2009 if journal == "American economic journal: economic policy" 
replace YEARintervention3 = 2009 if journal == "American economic journal: macroeconomics" 
replace YEARintervention3 = 2009 if journal == "American economic journal: microeconomics" 
replace YEARintervention3 = 2003 if journal == "Econometrica" 
replace YEARintervention3 = 2012 if journal == "European economic review"  
replace YEARintervention3 = 2011 if journal == "Journal of business and economic statistics"  
replace YEARintervention3 = 2014 if journal == "Journal of development economics" 
replace YEARintervention3 = 2013 if journal == "Journal of economic growth"
replace YEARintervention3 = 1990 if journal == "Journal of human resources"
replace YEARintervention3 = 2009 if journal == "Journal of labor economics"
replace YEARintervention3 = 1998 if journal == "Journal of money credit and banking"
replace YEARintervention3 = 2005 if journal == "Journal of political economy"
replace YEARintervention3 = 2011 if journal == "Journal of the european economic association"
replace YEARintervention3 = 2004 if journal == "The american economic review" 
replace YEARintervention3 = 2012 if journal == "The economic journal" 
replace YEARintervention3 = 2015 if journal == "The quarterly journal of economics" 
replace YEARintervention3 = 2009 if journal == "The review of economic studies" 
replace YEARintervention3 = 2010 if journal == "The review of economics and statistics" 
gen PUNTEY3 = 0
replace PUNTEY3 = YEARintervention3
replace PUNTEY3 = . if EVENT == 0
did_imputation tstat     Njournal yearsubmitted PUNTEY3 if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001) 
rename __* Anticipate51*
did_imputation tstat     Njournal yearsubmitted PUNTEY3 if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( Anticipate51w) pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY3 if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Anticipate51w)  pretrend(7)
ereturn list
* Column (4) allow for 1 year lag in enforcement
*** Any journal with mandated data-sharing allowing for one year delay in enforcement in all journals, e.g. 2009 policy change becomes effective in 2010 and 2009 to 2010 is a transition period.
gen YEARintervention1 = 0
replace YEARintervention1 = 2010 if journal == "American economic journal: applied economics" 
replace YEARintervention1 = 2010 if journal == "American economic journal: economic policy" 
replace YEARintervention1 = 2010 if journal == "American economic journal: macroeconomics" 
replace YEARintervention1 = 2010 if journal == "American economic journal: microeconomics" 
replace YEARintervention1 = 2005 if journal == "Econometrica" 
replace YEARintervention1 = 2013 if journal == "European economic review"  
replace YEARintervention1 = 2012 if journal == "Journal of business and economic statistics"  
replace YEARintervention1 = 2015 if journal == "Journal of development economics" 
replace YEARintervention1 = 2014 if journal == "Journal of economic growth"
replace YEARintervention1 = 1991 if journal == "Journal of human resources"
replace YEARintervention1 = 2010 if journal == "Journal of labor economics"
replace YEARintervention1 = 1999 if journal == "Journal of money credit and banking"
replace YEARintervention1 = 2007 if journal == "Journal of political economy"
replace YEARintervention1 = 2012 if journal == "Journal of the european economic association"
replace YEARintervention1 = 2006 if journal == "The american economic review" 
replace YEARintervention1 = 2013 if journal == "The economic journal" 
replace YEARintervention1 = 2017 if journal == "The quarterly journal of economics" 
replace YEARintervention1 = 2011 if journal == "The review of economic studies" 
replace YEARintervention1 = 2011 if journal == "The review of economics and statistics" 
gen PUNTEY1 = 0
replace PUNTEY1 = YEARintervention1
replace PUNTEY1 = . if EVENT == 0
did_imputation tstat     Njournal yearsubmitted PUNTEY1 if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* LagEnforce4*
did_imputation tstat     Njournal yearsubmitted PUNTEY1 if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( LagEnforce4w) pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY1 if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( LagEnforce4w) pretrend(7)
ereturn list
* Column (5) allow for 1 year lag in enforcement in non-top5
*** any journal with mandated data-sharing and allowing for one year delay in enforcement in non-top 5 journals
gen YEARintervention2 = 0
replace YEARintervention2 = 2010 if journal == "American economic journal: applied economics" 
replace YEARintervention2 = 2010 if journal == "American economic journal: economic policy" 
replace YEARintervention2 = 2010 if journal == "American economic journal: macroeconomics" 
replace YEARintervention2 = 2010 if journal == "American economic journal: microeconomics" 
replace YEARintervention2 = 2004 if journal == "Econometrica" 
replace YEARintervention2 = 2013 if journal == "European economic review"  
replace YEARintervention2 = 2012 if journal == "Journal of business and economic statistics"  
replace YEARintervention2 = 2015 if journal == "Journal of development economics" 
replace YEARintervention2 = 2014 if journal == "Journal of economic growth"
replace YEARintervention2 = 1991 if journal == "Journal of human resources"
replace YEARintervention2 = 2010 if journal == "Journal of labor economics"
replace YEARintervention2 = 1999 if journal == "Journal of money credit and banking"
replace YEARintervention2 = 2006 if journal == "Journal of political economy"
replace YEARintervention2 = 2012 if journal == "Journal of the european economic association"
replace YEARintervention2 = 2005 if journal == "The american economic review" 
replace YEARintervention2 = 2013 if journal == "The economic journal" 
replace YEARintervention2 = 2016 if journal == "The quarterly journal of economics" 
replace YEARintervention2 = 2010 if journal == "The review of economic studies" 
replace YEARintervention2 = 2011 if journal == "The review of economics and statistics" 
gen PUNTEY2 = 0
replace PUNTEY2 = YEARintervention2
replace PUNTEY2 = . if EVENT == 0
did_imputation tstat     Njournal yearsubmitted PUNTEY2 if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* LagEnforceNon54*
did_imputation tstat     Njournal yearsubmitted PUNTEY2 if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( LagEnforceNon54w) pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY2 if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( LagEnforceNon54w) pretrend(7)
ereturn list

*** TABLE 5 Robustness Checking: Large t-values and Marginal Statistical Significance
** Column (1) t-statistic less than 5
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & tstat < 5, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001) 
rename __* Lessthan54*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & tstat < 5, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Lessthan54w)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & tstat < 5, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Lessthan54w)
ereturn list
** Column (2)  t-statistic less than 10
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & tstat < 10, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* Lessthan104*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & tstat < 10, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Lessthan104w)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & tstat < 10, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Lessthan104w)
ereturn list
** Column (3)  t-statistic less than 20
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & tstat < 20, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* Lessthan204*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & tstat < 20, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Lessthan204w)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & tstat < 20, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Lessthan204w)
ereturn list
*** Column (4) All journals, statistically significant, alpha = 0.05
* Analysis of 'significant' and 'barely significant'
gen SIGNIFICANT = 0
replace SIGNIFICANT = 1 if tstat >=1.96
gen BARELYSIGNIFICANT = 0
replace BARELYSIGNIFICANT = 1 if tstat >=1.96 & tstat <= 2.58
reg SIGNIFICANT  c.YEAR##i.Njournal i.yearsubmitted i.Nresearcharea numberofauthors EXPERIMENT mixed temporal_rank   if Excludegroup !=1 & RETAIN ==1 & INTERVENTION !=1, cluster(studyid)
predict SIGpredict
sum SIGpredict if SIGpredict < 0 & Excludegroup !=1 & RETAIN ==1 & INTERVENTION !=1 | SIGpredict > 1 & Excludegroup !=1 & RETAIN ==1 & INTERVENTION !=1 
did_imputation SIGNIFICANT Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* Sign4*
did_imputation SIGNIFICANT Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Sign4w)  pretrend(7)
ereturn list
*** Column (4) All journals, barely statistically significant 
reg BARELYSIGNIFICANT  c.YEAR##i.Njournal i.yearsubmitted i.Nresearcharea numberofauthors EXPERIMENT mixed temporal_rank   if Excludegroup !=1 & RETAIN ==1 & INTERVENTION !=1, cluster(studyid)
predict BARELYpredict
sum SIGpredict if BARELYpredict < 0 & Excludegroup !=1 & RETAIN ==1 & INTERVENTION !=1 | BARELYpredict > 1 & Excludegroup !=1 & RETAIN ==1 & INTERVENTION !=1 
did_imputation BARELYSIGNIFICANT Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* Barely4*
did_imputation BARELYSIGNIFICANT Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Barely4w)  pretrend(7)
ereturn list
*** Column (5) Top 5 journals, statistically significant, alpha = 0.05
did_imputation SIGNIFICANT Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & Excludegroup5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* Signtop54*
did_imputation SIGNIFICANT Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & Excludegroup5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Signtop54w)  pretrend(7)
ereturn list
*** Column (5) Top 5 journals, 'barely statistically significant'
did_imputation BARELYSIGNIFICANT Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & Excludegroup5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* Barelytop54*
did_imputation BARELYSIGNIFICANT Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & Excludegroup5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Barelytop54w)  pretrend(7)
ereturn list
*** Column (6) non-Top 5 journals, statistically significant, alpha = 0.05
did_imputation SIGNIFICANT Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & Excludegroupnon5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors  EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* Signnontop54*
did_imputation SIGNIFICANT Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & Excludegroupnon5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Signnontop54w)  pretrend(7)
ereturn list
*** Column (6) non-Top 5 journals, 'barely statistically significant'
did_imputation BARELYSIGNIFICANT Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & Excludegroupnon5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* Barelynontop54*
did_imputation BARELYSIGNIFICANT Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & Excludegroupnon5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Barelynontop54w)  pretrend(7)
ereturn list

*** alternate outcome, reported in Footnote 44
gen t5 = 0
replace t5 = 1 if tstat >= 5
did_imputation t5 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* t54*
did_imputation t5 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR)  autosample cluster(studyid) loadweights(t54w) maxit(1000) tol(0.001)

*** SECTION 5.3, FALSIFICATION TESTS 
*** TEST 1, randomization inference using all sample data i.e. permutation of baseline did model (this includes data with data-sharing) 
*** these commands produce the density plots, Figures S3 to S6, reported in the Online Supplement, 
ritest PUNTEY _b[tau], reps(1000) seed(10) kdensityplot: did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( TWFERunittrendaweight4w)
ritest PUNTEY _b[tau], reps(1000) seed(10) kdensityplot: did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( TWFERunittrendaweight4w)
ritest PUNTEY _b[tau], reps(1000) seed(10) kdensityplot: did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( unittrendaweightAntw) shift(1)        
ritest PUNTEY _b[tau], reps(1000) seed(10) kdensityplot: did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( unittrendaweightAntw) shift(1)  

*** TEST 2, assume data-sharing mandated four years earlier, and use only data from years without mandated data-sharing
*** create fake intervention
gen FAKEYEARintervention = YEARintervention - 4
replace FAKEYEARintervention = 0 if FAKEYEARintervention == -4
gen PUNFAKE = 0
replace PUNFAKE = FAKEYEARintervention
replace PUNFAKE = . if EVENT == 0
did_imputation tstat     Njournal yearsubmitted PUNFAKE if Excludegroup !=1 & INTERVENTION !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank)  unitcontrols(YEAR) autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* False14*
did_imputation tstat     Njournal yearsubmitted PUNFAKE if Excludegroup !=1 & INTERVENTION !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank)  unitcontrols(YEAR) autosample cluster(studyid) loadweights( False14w ) maxit(1000) tol(0.001)
did_imputation ex_sig196 Njournal yearsubmitted PUNFAKE if Excludegroup !=1 & INTERVENTION !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank)  unitcontrols(YEAR) autosample cluster(studyid) loadweights( False14w ) maxit(1000) tol(0.001)
*** footnote 47; ignores data from t-1 as there may have been anticipation one year prior to mandated data-sharing.
gen RETAINfalse  = 0
replace RETAINfalse = 1 if journal == "The american economic review" & yearsubmitted < 2004 
replace RETAINfalse = 1 if journal == "Journal of political economy" & yearsubmitted < 2005 
replace RETAINfalse = 1 if journal == "The quarterly journal of economics" & yearsubmitted < 2015 
replace RETAINfalse = 1 if journal == "The review of economic studies" & yearsubmitted < 2009 
replace RETAINfalse = 1 if journal == "Econometrica" &  yearsubmitted < 2003 
replace RETAINfalse = 1 if journal == "The review of economics and statistics" & yearsubmitted < 2009
replace RETAINfalse = 1 if journal == "European economic review" &  yearsubmitted < 2011 
replace RETAINfalse = 1 if journal == "The economic journal" &  yearsubmitted < 2011 
replace RETAINfalse = 1 if journal == "Journal of the european economic association" & yearsubmitted <  2010 
replace RETAINfalse = 1 if journal == "Journal of development economics" &  yearsubmitted < 2013 
replace RETAINfalse = 1 if journal == "Journal of money credit and banking" &  yearsubmitted < 1997 
replace RETAINfalse = 1 if journal == "Journal of human resources" &  yearsubmitted < 1989 
replace RETAINfalse = 1 if journal == "Journal of labor economics" &  yearsubmitted < 2008
replace RETAINfalse = 1 if EVENT   == 0
replace RETAINfalse = 1 if journal == "Journal of business and economic statistics"
replace RETAINfalse = 1 if journal == "Journal of economic growth"
gen FAKEYEARinterventionant = YEARintervention - 5
replace FAKEYEARinterventionant = 0 if FAKEYEARintervention == -5
gen PUNFAKEant = 0
replace PUNFAKEant = FAKEYEARinterventionant
replace PUNFAKEant = . if EVENT == 0
did_imputation tstat     Njournal yearsubmitted PUNFAKEant if Excludegroup !=1 & INTERVENTION !=1 & RETAINfalse ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank)  unitcontrols(YEAR) autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* False14ant*
did_imputation tstat     Njournal yearsubmitted PUNFAKEant if Excludegroup !=1 & INTERVENTION !=1 & RETAINfalse ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank)  unitcontrols(YEAR) autosample cluster(studyid) loadweights( False14antw ) maxit(1000) tol(0.001)
did_imputation ex_sig196 Njournal yearsubmitted PUNFAKEant if Excludegroup !=1 & INTERVENTION !=1 & RETAINfalse ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank)  unitcontrols(YEAR) autosample cluster(studyid) loadweights( False14antw ) maxit(1000) tol(0.001)

***********************************************************************************************************************************************************************************************
*** FIGURES
***********************************************************************************************************************************************************************************************
*** Figure 1 Distribution of test statistics, data-sharing and other journals
*** Use data in file 'Mandatory data-sharing 1 Aug 2022.dta', except for figure D.
** panel A. Data-sharing journals pre-sharing vs other journals
twoway (kdensity tstat if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==0 & tstat < 10) (kdensity tstat if tstat < 10 & EVENT ==0 & Excludegroup !=1)
sum tstat if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==0
sum tstat if EVENT ==0 & Excludegroup !=1
** panel B. Data-sharing journals, pre- and post-sharing (four years post data sharing)
twoway (kdensity tstat if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==1 & tstat < 10 & leadlag < 5) (kdensity tstat if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==0 & tstat < 10)
sum tstat if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==1 & leadlag < 5
sum tstat if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==0 
** panel C. Data-sharing journals, post-sharing (four years post data sharing) vs other journals 
twoway (kdensity tstat if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==1 & tstat < 10 & leadlag < 5) (kdensity tstat if EVENT ==0 & Excludegroup !=1  & tstat < 10)
sum tstat if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==1 & leadlag < 5 
sum tstat if EVENT ==0 & Excludegroup !=1  
** panel D. Difference in t-statistics pre- and post-treatment.
*** For this graph use the data in file Time series.data
twoway ( line withdatasharing Yearpublished) ( line Other Yearpublished)
** panel E. Data-sharing journals, macroeconomic research, pre- and post-sharing 
twoway (kdensity tstat if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==1 & tstat < 10 & leadlag < 5 & MACRO ==1) (kdensity tstat if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==0 & tstat < 10 & MACRO ==1)
sum tstat if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==1 & leadlag < 5 & MACRO ==1
sum tstat if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==0 & MACRO ==1
** panel F. Data-sharing journals, non-macroeconomic research, pre- and post-sharing
twoway (kdensity tstat if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==1 & tstat < 10 & leadlag < 5 & MACRO ==0) (kdensity tstat if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==0 & tstat < 10 & MACRO ==0)
sum tstat if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==1 & leadlag < 5 & MACRO ==0
sum tstat if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==0 & MACRO ==0

*** Figure 2: Distribution of test statistics for different research areas, pre- and post-data-sharing
** panel A: Forward premium puzzle
twoway (kdensity tstat if tstat < 10 & INTERVENTION == 1 & Excludegroup !=1 & filename == "forward premium puzzle.xlsx") (kdensity tstat if tstat < 10 & INTERVENTION == 0 & Excludegroup !=1 & filename == "forward premium puzzle.xlsx")
** panel B: Inflation targeting and inflation volatility
twoway (kdensity tstat if tstat < 10 & INTERVENTION == 1 & Excludegroup !=1 & filename == "Inflation targetting and inflation volatility.xlsx") (kdensity tstat if tstat < 10 & INTERVENTION == 0 & Excludegroup !=1 & filename == "Inflation targetting and inflation volatility.xlsx")
** panel C: Monopsony in labor market
twoway (kdensity tstat if tstat < 10 & INTERVENTION == 1 & Excludegroup !=1 & filename == "Monopsony in Labour Markets.xlsx") (kdensity tstat if tstat < 10 & INTERVENTION == 0 & Excludegroup !=1 & filename == "Monopsony in Labour Markets.xlsx")
** panel C: Sensitivity of consumption to income, American Economic Review
twoway (kdensity tstat if tstat < 15 & yearsubmitted >= 2005 & journal == "The american economic review" & filename == "sensitivity of consumption to income.xlsx") (kdensity tstat if tstat < 15 & yearsubmitted < 2005 & journal == "The american economic review" & filename == "sensitivity of consumption to income.xlsx")
** panel D: Borders and trade, American Economic Review
twoway (kdensity tstat if tstat < 20 & yearsubmitted >= 2005 & journal == "The american economic review" & filename == "border effects of trade.xlsx") (kdensity tstat if tstat < 20 & yearsubmitted < 2005 & journal == "The american economic review" & filename == "border effects of trade.xlsx")
** panel E: Elasticity of taxable income, Review of Economics and Statistics
twoway (kdensity tstat if tstat < 10 & INTERVENTION == 1 & Excludegroup !=1 & filename == "Monopsony in Labour Markets.xlsx" & journal == "Journal of labor economics") (kdensity tstat if tstat < 10 & INTERVENTION == 0 & Excludegroup !=1 & filename == "Monopsony in Labour Markets.xlsx" & journal == "Journal of labor economics")

*** Figure 3: Distribution of excess statistical significance
** panel A. Data-sharing journals vs other journals
twoway (kdensity ex_sig196 if ex_sig196 >= 0 & EVENT == 1 & Excludegroup != 1 & INTERVENTION ==0) (kdensity ex_sig196 if ex_sig196 >= 0 & EVENT == 0 & Excludegroup != 1)
sum ex_sig196 if ex_sig196 >= 0 & EVENT == 1 & Excludegroup != 1 & INTERVENTION ==0
sum ex_sig196 if ex_sig196 >= 0 & EVENT == 0 & Excludegroup != 1
** panel B. Data-sharing journals, pre- vs post-sharing
twoway (kdensity ex_sig196 if ex_sig196 >=0 & EVENT ==1 & Excludegroup !=1 & INTERVENTION ==1) (kdensity ex_sig196 if ex_sig196 >=0 & EVENT ==1 & Excludegroup !=1 & INTERVENTION ==0)
sum ex_sig196 if ex_sig196 >=0 & EVENT ==1 & Excludegroup !=1 & INTERVENTION ==1 
sum ex_sig196 if ex_sig196 >=0 & EVENT ==1 & Excludegroup !=1 & INTERVENTION ==0
** panel C. Data-sharing journals, post-sharing (four years post data sharing) vs other journals 
twoway (kdensity ex_sig196 if ex_sig196 >=0 & EVENT ==1 & Excludegroup !=1 & INTERVENTION ==1) (kdensity ex_sig196 if ex_sig196 >=0 & EVENT ==0 & Excludegroup !=1)
sum ex_sig196 if ex_sig196 >=0 & EVENT ==1 & Excludegroup !=1 & INTERVENTION ==1 
sum ex_sig196 if ex_sig196 >=0 & EVENT ==0 & Excludegroup !=1 
*** panel D.
*** Use Time series.data
twoway ( line ESSdatasharing Yearpublished) ( line ESSother Yearpublished)
*** Distribution of ESS for control journals
** E. Data-sharing journals, macroeconomic research, pre- and post-sharing
twoway (kdensity ex_sig196 if EVENT == 1 & Excludegroup != 1 & INTERVENTION == 1 & leadlag < 5 & MACRO == 1 & ex_sig196 >= 0) (kdensity ex_sig196 if EVENT == 1 & Excludegroup != 1 & INTERVENTION == 0 &  MACRO == 1 & ex_sig196 >= 0)
sum ex_sig196 if EVENT == 1 & Excludegroup != 1 & INTERVENTION == 1 & leadlag < 5 & MACRO == 1 & ex_sig196 >= 0
sum ex_sig196 if EVENT == 1 & Excludegroup != 1 & INTERVENTION == 0 & leadlag < 5 & MACRO == 1 & ex_sig196 >= 0
** F. Data-sharing journals, non-macroeconomic research, pre- and post-sharing
twoway (kdensity ex_sig196 if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==1 & leadlag < 5 & MACRO ==0 & ex_sig196 >=0) (kdensity ex_sig196 if EVENT ==1 & Excludegroup !=1 & INTERVENTION ==0 &  MACRO ==0 & ex_sig196 >=0)
sum ex_sig196 if EVENT == 1 & Excludegroup != 1 & INTERVENTION == 1 & leadlag < 5 & MACRO == 0 & ex_sig196 >= 0
sum ex_sig196 if EVENT == 1 & Excludegroup != 1 & INTERVENTION == 0 & leadlag < 5 & MACRO == 0 & ex_sig196 >= 0

*** FIGURE 5 Reported t-test values and mandated data sharing, all journals, four years post-data-sharing
*** allows for 5 horizons, one pre and 4 post, all journals
did_imputation tstat Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR) autosample cluster(studyid) horizons(0/5) maxit(1000) tol(0.001) saveweight pretrend(7) shift(1)
rename __* anti5horizons*
did_imputation tstat Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR) autosample cluster(studyid) horizons(0/5) maxit(1000) tol(0.001) loadweights(anti5horizons*) pretrend(7) shift(1)
ereturn list
event_plot, default_look alpha(0.10) ciplottype(rcap) shift(1)
** test lags
test tau0  tau1  tau2  tau3  tau4 tau5
** test leads
test pre1 pre2 pre3 pre4 pre5 pre6 pre7

*** FIGURE 6 ESS and mandated data sharing, all journals, four years post-data-sharing
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR) autosample cluster(studyid) horizons(0/5) maxit(1000) tol(0.001) loadweights(anti5horizons*) pretrend(7) shift(1)
event_plot, default_look alpha(0.10) ciplottype(rcap) shift(1)
** test lags
test tau0  tau1  tau2  tau3  tau4 tau5, df()
** test leads
test pre1 pre2 pre3 pre4 pre5 pre6 pre7, df()


**********************************************************************************************************************************************************************************************
*** Other results used in the main paper
** Change in raw averages, data-sharing journals, four-years post data-sharing mentioned in the Introduction.
sum tstat     if EVENT == 1 & INTERVENTION == 0 & Excludegroup != 1 & RETAIN == 1 
sum tstat     if EVENT == 1 & INTERVENTION == 1 & Excludegroup != 1 & RETAIN == 1
sum ex_sig196 if EVENT == 1 & INTERVENTION == 0 & Excludegroup != 1 & RETAIN == 1
sum ex_sig196 if EVENT == 1 & INTERVENTION == 1 & Excludegroup != 1 & RETAIN == 1

**********************************************************************************************************************************************************************************************
*** PART B. RESULTS REPORTED IN THE ONLINE SUPPLEMENT
**********************************************************************************************************************************************************************************************
*** Table S1: Covariate descriptive statistics
sum tstat ex_sig196 numberofauthors temporal_rank EXPERIMENT mixed if  RETAIN ==1 & Excludegroup !=1 

***TABLE S2  Mandatory data-sharing, Difference-in-Differences, BJS DD imputation estimator, results for covariates
*** Panel A.	Without anticipation
*** column (1) t-value
reg tstat numberofauthors temporal_rank EXPERIMENT mixed i.Njournal i.yearsubmitted i.Nresearcharea if Excludegroup !=1 & RETAIN ==1 & INTERVENTION !=1,  cluster(studyid) 
*** column (2) ESS
reg ex_sig196 numberofauthors temporal_rank EXPERIMENT mixed i.Njournal i.yearsubmitted i.Nresearcharea if Excludegroup !=1 & RETAIN ==1 & INTERVENTION !=1,  cluster(studyid) 
*** column (3) t-value
reg tstat numberofauthors temporal_rank EXPERIMENT mixed c.YEAR##i.Njournal i.yearsubmitted i.Nresearcharea if Excludegroup !=1 & RETAIN ==1 & INTERVENTION !=1,  cluster(studyid) 
*** column (4) ESS
reg ex_sig196 numberofauthors temporal_rank EXPERIMENT mixed c.YEAR##i.Njournal i.yearsubmitted i.Nresearcharea if Excludegroup !=1 & RETAIN ==1 & INTERVENTION !=1,  cluster(studyid) 
*** Panel B. With anticipation
*** column (1) t-value
reg tstat numberofauthors temporal_rank EXPERIMENT mixed i.Njournal i.yearsubmitted i.Nresearcharea if Excludegroup !=1 & RETAIN ==1 & INTERVENTION1 !=1,  cluster(studyid) 
*** column (2) ESS
reg ex_sig196  numberofauthors temporal_rank EXPERIMENT mixed i.Njournal i.yearsubmitted i.Nresearcharea if Excludegroup !=1 & RETAIN ==1 & INTERVENTION1 !=1,  cluster(studyid) 
*** column (3) t-value
reg tstat     numberofauthors temporal_rank EXPERIMENT mixed c.YEAR##i.Njournal i.yearsubmitted i.Nresearcharea if Excludegroup !=1 & RETAIN ==1 & INTERVENTION1 !=1,  cluster(studyid) 
*** column (4) ESS
reg ex_sig196 numberofauthors temporal_rank EXPERIMENT mixed c.YEAR##i.Njournal i.yearsubmitted i.Nresearcharea if Excludegroup !=1 & RETAIN ==1 & INTERVENTION1 !=1,  cluster(studyid) 


*** TABLE S3 Robustness checks with anticipation of policy
* Column (1) top 5 
did_imputation tstat     Njournal yearsubmitted PUNTEY if RETAIN ==1 & Excludegroup5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed)  unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001) shift(1)
rename __* Top54ant*
did_imputation tstat     Njournal yearsubmitted PUNTEY if RETAIN ==1 & Excludegroup5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( Top54ant) shift(1) pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if RETAIN ==1 & Excludegroup5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors  temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Top54ant) shift(1) pretrend(7)
ereturn list
*** Column (2) non-top 5
did_imputation tstat     Njournal yearsubmitted PUNTEY if RETAIN ==1 & Excludegroupnon5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001) shift(1)
rename __* NonTop54ant*
did_imputation tstat     Njournal yearsubmitted PUNTEY if RETAIN ==1 & Excludegroupnon5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( NonTop54antw) shift(1) pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if RETAIN ==1 & Excludegroupnon5 !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( NonTop54antw) shift(1) pretrend(7)
ereturn list
*** Column (3) without JHR and JMCB
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & WithoutJHR !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001) shift(1)
rename __* noJHR4ant*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & WithoutJHR !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors  temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( noJHR4antw) shift(1) pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & WithoutJHR !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors  temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( noJHR4antw) shift(1) pretrend(7)
ereturn list
*** Column (4) Post-1999 (from year 2000 onwards horizon)
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & YEAR >=2000, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001) shift(1)
rename __* y20004ant*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & YEAR >=2000, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( y20004antw) shift(1) pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & YEAR >=2000, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights(y20004antw) shift(1) pretrend(7)
ereturn list
** Column(5) Pre- & post- research areas (89 Research areas with pre- and post-data-sharing observations)
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & WITHPREANDPOST ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001) shift(1)
rename __* unittrendaweightPrePostant*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & WITHPREANDPOST ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( unittrendaweightPrePostantw) shift(1) pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & WITHPREANDPOST ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( unittrendaweightPrePostantw) shift(1) pretrend(7)
ereturn list
*** Column (6) Balanced panel
did_imputation tstat Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & PostPanel !=1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001) shift(1)
rename __* PostPanel4ant*
did_imputation tstat   Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & PostPanel !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( PostPanel4antw) pretrend(7) shift(1)
ereturn list
did_imputation ex_sig196  Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & PostPanel !=1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( PostPanel4antw) pretrend(7) shift(1)
ereturn list
*** Column (7) macroeconomic research
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & MACRO ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001) shift(1)
rename __* Macro4ant*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & MACRO ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( Macro4antw) pretrend(7) shift(1)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 & MACRO ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( Macro4antw) pretrend(7) shift(1)
ereturn list

*** Table S4 - Robustness checks, alternate ways to estimate mean effect (used to calculate ESS)
*** Panel A. Without anticipation
** Column(1) PEESE (corrects evidence base for publication bias)
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( TWFERunittrendaweight4w)  pretrend(7)
ereturn list
did_imputation ex_sig196peese Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( TWFERunittrendaweight4w)  pretrend(7)
ereturn list
*** Column(2) Random effects weights
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( TWFERunittrendaweight4w)  pretrend(7)
ereturn list
did_imputation ex_sig196re Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( TWFERunittrendaweight4w)  pretrend(7)
ereturn list
** Column(3) Mean effect calculated using only top 31 journals (ie. discard estimates published in all other journals)
*** For this analysis, use the data file: 'Using only top 31.dta'
did_imputation tstat Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* TWFERunittrendaweight4*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( TWFERunittrendaweight4w)  pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( TWFERunittrendaweight4w)  pretrend(7)
ereturn list
** Column(4) Outliers and leverage points included
*** For this analysis, use the data file: 'With Outliers Included 30 Aug.dta' 
did_imputation tstat Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(studyid) saveweights maxit(1000) tol(0.001)
rename __* TWFERunittrendaweight4*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( TWFERunittrendaweight4w)  pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( TWFERunittrendaweight4w)  pretrend(7)
ereturn list
*** Panel B. With anticipation
** Column(1) PEESE
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( unittrendaweightAntw) shift(1) pretrend(7)        
ereturn list
did_imputation ex_sig196peese Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( unittrendaweightAntw) shift(1) pretrend(7)        
ereturn list
*** Column(2) Random effects weights
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( unittrendaweightAntw) shift(1) pretrend(7)        
ereturn list
did_imputation ex_sig196re Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( unittrendaweightAntw) shift(1) pretrend(7)        
ereturn list
** Column(3) Mean effect calculated using only top 31 journals
*** For this analysis, use the data file: 'Using only top 31.dta'
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1,  fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed ) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001) shift(1)
rename __* unittrendaweightAnt*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( unittrendaweightAntw) shift(1) pretrend(7)        
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( unittrendaweightAntw) shift(1) pretrend(7)        
ereturn list
** Column(4) Outliers and leverage points included
*** For this analysis, use the data file: 'With Outliers Included 30 Aug.dta'
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1,  fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed ) unitcontrols(YEAR)  autosample cluster(studyid) saveweights maxit(1000) tol(0.001) shift(1)
rename __* unittrendaweightAnt*
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights( unittrendaweightAntw) shift(1) pretrend(7)        
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( unittrendaweightAntw) shift(1) pretrend(7)        
ereturn list

*** TABLE S5 Difference-in-Differences, BJS DD imputation estimator, one-tail tests
** Panel A.	Four-year post-data-sharing window
* Column (1) No fixed effects or covariates
did_imputation onesidedESS Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(.) autosample cluster(studyid) maxit(1000) loadweights( Baseweight4 ) pretrend(7)
ereturn list
* Column(2) Plus journal and time fixed effects 
did_imputation onesidedESS Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted) autosample cluster(studyid) maxit(1000) loadweights( TWFEweight4) pretrend(7)    
ereturn list
* Column(3) Plus field of research effects 
did_imputation onesidedESS Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) autosample cluster(studyid) maxit(1000) loadweights(TWFERareaweight4) pretrend(7)   
ereturn list
* Column(4) Plus covariates
did_imputation onesidedESS Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) autosample cluster(studyid) maxit(1000) loadweights( TWFERareacovaweight4 ) pretrend(7)   
ereturn list
* Column(5) Plus journal specific trends
did_imputation onesidedESS Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( TWFERunittrendaweight4)  pretrend(7)
ereturn list
// TABLE S5, Panel B.	Allowing for anticipation effects, four-year post-data-sharing window
* Column (1) No fixed effects or covariates
did_imputation onesidedESS Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(.) autosample cluster(studyid) maxit(1000) loadweights( Ant4) shift(1) pretrend(7)   
ereturn list
* Column(2) Plus journal and time fixed effects 
did_imputation onesidedESS Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted) autosample cluster(studyid) maxit(1000) loadweights(TWFEweightAnt4) shift(1) pretrend(7)     
ereturn list
* Column(3) Plus field of research effects 
did_imputation onesidedESS Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) autosample cluster(studyid) maxit(1000) loadweights(TWFERareaweightAnt) shift(1) pretrend(7)        
ereturn list
* Column(4) Plus covariates
did_imputation onesidedESS Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank  EXPERIMENT mixed) autosample cluster(studyid) maxit(1000) loadweights( TWFERareacovaweightAnt ) shift(1) pretrend(7)       
ereturn list
* Column(5) Plus journal specific trends
did_imputation onesidedESS Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(studyid) maxit(1000) tol(0.001) loadweights( unittrendaweightAnt) shift(1) pretrend(7)        
ereturn list


*** TABLE S6, Mandatory data-sharing, Difference-in-Differences, BJS DD imputation estimator, clustering by journal
** Panel A.	Four-year post-data-sharing window
* Column (1) No fixed effects or covariates
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(.) autosample cluster(Njournal) maxit(1000) loadweights( Baseweight4 ) pretrend(7)   
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(.) autosample cluster(Njournal) maxit(1000) loadweights( Baseweight4 ) pretrend(7)
ereturn list
* Column(2) Plus journal and time fixed effects 
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted) autosample cluster(Njournal) maxit(1000) loadweights( TWFEweight4 ) pretrend(7)   
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted) autosample cluster(Njournal) maxit(1000) loadweights( TWFEweight4) pretrend(7)    
ereturn list
* Column(3) Plus field of research effects 
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) autosample cluster(Njournal) maxit(1000) loadweights( TWFERareaweight4 )  pretrend(7)  
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) autosample cluster(Njournal) maxit(1000) loadweights(TWFERareaweight4) pretrend(7)   
ereturn list
* Column(4) Plus covariates
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) autosample cluster(Njournal) maxit(1000) loadweights( TWFERareacovaweight4 ) pretrend(7)   
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) autosample cluster(Njournal) maxit(1000) loadweights( TWFERareacovaweight4 ) pretrend(7)   
ereturn list
* Column(5) Plus journal specific trends
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(Njournal)  maxit(1000) tol(0.001) loadweights( TWFERunittrendaweight4)  pretrend(7)
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR) autosample cluster(Njournal) maxit(1000) tol(0.001) loadweights( TWFERunittrendaweight4)  pretrend(7)
ereturn list
// TABLE S6, Panel B.	Allowing for anticipation effects, four-year post-data-sharing window
* Column (1) No fixed effects or covariates
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(.) autosample cluster(Njournal) maxit(1000) loadweights( Ant4) shift(1) pretrend(7)  
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(.) autosample cluster(Njournal) maxit(1000) loadweights( Ant4) shift(1) pretrend(7)   
ereturn list
* Column(2) Plus journal and time fixed effects 
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted) autosample cluster(Njournal) maxit(1000) loadweights(TWFEweightAnt4) shift(1) pretrend(7)     
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted) autosample cluster(Njournal) maxit(1000) loadweights(TWFEweightAnt4) shift(1) pretrend(7)     
ereturn list
* Column(3) Plus field of research effects 
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) autosample cluster(Njournal) maxit(1000) loadweights(TWFERareaweightAnt) shift(1) pretrend(7)        
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) autosample cluster(Njournal) maxit(1000) loadweights(TWFERareaweightAnt) shift(1) pretrend(7)        
ereturn list
* Column(4) Plus covariates
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank  EXPERIMENT mixed) autosample cluster(Njournal) maxit(1000) loadweights( TWFERareacovaweightAnt ) shift(1) pretrend(7)          
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank  EXPERIMENT mixed) autosample cluster(Njournal) maxit(1000) loadweights( TWFERareacovaweightAnt ) shift(1) pretrend(7)        
ereturn list
* Column(5) Plus journal specific trends
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(Njournal)  maxit(1000) tol(0.001) loadweights( unittrendaweightAnt) shift(1) pretrend(7)        
ereturn list
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1 , fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed) unitcontrols(YEAR)  autosample cluster(Njournal) maxit(1000) tol(0.001) loadweights( unittrendaweightAnt) shift(1) pretrend(7)        
ereturn list

*** TABLE S7 Event study estimates 
*** allows for 5 horizons, one pre and 4 post, all journals
did_imputation tstat Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR) autosample cluster(studyid) horizons(0/5) maxit(1000) tol(0.001) saveweight pretrend(7) shift(1)
rename __* anti5horizons*
did_imputation tstat Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR) autosample cluster(studyid) horizons(0/5) maxit(1000) tol(0.001) loadweights(anti5horizons*) pretrend(7) shift(1)
ereturn list
test tau0 tau1 tau2 tau3 tau4 tau5
test pre1 pre2 pre3 pre4 pre5 pre6 pre7
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors EXPERIMENT mixed temporal_rank) unitcontrols(YEAR) autosample cluster(studyid) horizons(0/5) maxit(1000) tol(0.001) loadweights(anti5horizons*) pretrend(7) shift(1)
ereturn list
test tau0 tau1 tau2 tau3 tau4 tau5
test pre1 pre2 pre3 pre4 pre5 pre6 pre7

*** TABLE S8 Controlling for Editorial Decision Makers, BJS DD imputation estimator 
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed numberofuniqueeditors propneweditors )  autosample cluster(studyid)  maxit(1000) tol(0.001) saveweights   pretrend(7)
rename __* Editorsw*
* column (1)
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed numberofuniqueeditors propneweditors ) autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights(  Editorsw)  pretrend(7)
* column (2)
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed numberofuniqueeditors propneweditors ) autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights(  Editorsw)  pretrend(7)

did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed numberofuniqueeditors propneweditors ) unitcontrols(YEAR) autosample cluster(studyid)  maxit(1000) tol(0.001) saveweights   pretrend(7)
rename __* Editorstw*
* column (3)
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed numberofuniqueeditors propneweditors ) unitcontrols(YEAR) autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights(  Editorstw)  pretrend(7)
* column (4)
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed numberofuniqueeditors propneweditors  ) unitcontrols(YEAR) autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights(  Editorstw)  pretrend(7)

did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed numberofuniqueeditors propneweditors ) unitcontrols(YEAR) autosample cluster(studyid)  maxit(1000) tol(0.001) saveweights   pretrend(7) shift(1)
rename __* Editorsant*
* column (5)
did_imputation tstat     Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed numberofuniqueeditors propneweditors ) unitcontrols(YEAR) autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights(  Editorsantw)  pretrend(7) shift(1)
* column (6)
did_imputation ex_sig196 Njournal yearsubmitted PUNTEY if Excludegroup !=1 & RETAIN ==1, fe(Njournal yearsubmitted Nresearcharea) controls(numberofauthors temporal_rank EXPERIMENT mixed numberofuniqueeditors propneweditors ) unitcontrols(YEAR) autosample cluster(studyid)  maxit(1000) tol(0.001) loadweights(  Editorsantw)  pretrend(7) shift(1)

*** TABLE S10 Difference-in-Differences, OLS estimates
// These results use data in the file: 'Stacked data 30 Aug.dta' 
* Panel A.	Four-year post data-sharing window
gen filterout = 0
replace filterout = 1 if leverage_point =="TRUE" |  outlier == "TRUE" | outlier_tstat =="TRUE"
gen TREATMENT = 0 
replace TREATMENT = 1 if journaladoptingsharing =="The american economic review" & journal == "The american economic review" & yearsubmitted >= 2005
replace TREATMENT = 1 if journaladoptingsharing =="Journal of political economy" & journal == "Journal of political economy" & yearsubmitted >= 2006
replace TREATMENT = 1 if journaladoptingsharing =="The quarterly economic journal" & journal == "The quarterly journal of economics" & yearsubmitted >= 2016
replace TREATMENT = 1 if journaladoptingsharing =="The quarterly journal of economics" & journal == "The quarterly journal of economics" & yearsubmitted >= 2016
replace TREATMENT = 1 if journaladoptingsharing =="The review of economic studies" & journal == "The review of economic studies" & yearsubmitted >= 2010
replace TREATMENT = 1 if journaladoptingsharing =="Econometrica" & journal == "Econometrica" & yearsubmitted >= 2004
replace TREATMENT = 1 if journaladoptingsharing =="The review of economics and statistics" & journal == "The review of economics and statistics" & yearsubmitted >= 2010 
replace TREATMENT = 1 if journaladoptingsharing =="European economic review" & journal == "European economic review" & yearsubmitted >= 2012 
replace TREATMENT = 1 if journaladoptingsharing =="The economic journal" & journal == "The economic journal" & yearsubmitted >= 2012 
replace TREATMENT = 1 if journaladoptingsharing =="Journal of the european economic association" & journal == "Journal of the european economic association"  & yearsubmitted >= 2011 
replace TREATMENT = 1 if journaladoptingsharing =="Journal of development economics" & journal == "Journal of development economics"  & yearsubmitted >= 2014 
replace TREATMENT = 1 if journaladoptingsharing =="Journal of money credit and banking" & journal == "Journal of money credit and banking" & yearsubmitted >= 1998 
replace TREATMENT = 1 if journaladoptingsharing =="Journal of human resources" & journal == "Journal of human resources" & yearsubmitted >= 1990 
replace TREATMENT = 1 if journaladoptingsharing =="Journal of labor economics" & journal == "Journal of labor economics" & yearsubmitted >= 2009 
gen     RETAINS = 0
replace RETAINS = 1 if journaladoptingsharing == "The american economic review" & yearsubmitted <=2009 
replace RETAINS = 1 if journaladoptingsharing == "Journal of political economy" & yearsubmitted <=2010 
replace RETAINS = 1 if journaladoptingsharing == "The quarterly journal of economics" & yearsubmitted <=2020 
replace RETAINS = 1 if journaladoptingsharing == "The review of economic studies" & yearsubmitted <=2014 
replace RETAINS = 1 if journaladoptingsharing == "Econometrica" &  yearsubmitted <=2008 
replace RETAINS = 1 if journaladoptingsharing == "The review of economics and statistics" & yearsubmitted <=2014
replace RETAINS = 1 if journaladoptingsharing == "European economic review" &  yearsubmitted <=2016 
replace RETAINS = 1 if journaladoptingsharing == "The economic journal" &  yearsubmitted <=2016 
replace RETAINS = 1 if journaladoptingsharing == "Journal of the european economic association" & yearsubmitted <= 2015 
replace RETAINS = 1 if journaladoptingsharing == "Journal of development economics" &  yearsubmitted <=2018 
replace RETAINS = 1 if journaladoptingsharing == "Journal of money credit and banking" &  yearsubmitted <=2002 
replace RETAINS = 1 if journaladoptingsharing == "Journal of human resources" &  yearsubmitted <=1994 
replace RETAINS = 1 if journaladoptingsharing == "Journal of labor economics" &  yearsubmitted <=2013
replace RETAINS = 1 if EVENT   == 0
replace RETAINS = 1 if journal == "Journal of business and economic statistics"
replace RETAINS = 1 if journal == "Journal of economic growth"
** No anticipation, no weights
* Column (1)
reg tstat TREATMENT if filterout !=1 & RETAINS ==1  & Excludegroup !=1 , cluster( studyid)
reg ex_sig196 TREATMENT if filterout !=1 & RETAIN ==1 & Excludegroup !=1, cluster( studyid)
* Column (2)
reg tstat i.yearsubmitted i.Njournal TREATMENT if filterout !=1 & RETAIN ==1  & Excludegroup !=1 , cluster( studyid)
reg ex_sig196 i.yearsubmitted i.Njournal TREATMENT if filterout !=1 & RETAIN ==1 & Excludegroup !=1, cluster( studyid)
* Column (3)
reg tstat i.yearsubmitted i.Njournal i.Nresearcharea TREATMENT if filterout !=1 & RETAIN ==1  & Excludegroup !=1 , cluster( studyid)
reg ex_sig196 i.yearsubmitted i.Njournal i.Nresearcharea TREATMENT if filterout !=1 & RETAIN ==1 & Excludegroup !=1, cluster( studyid)
* Column (4)
reg tstat EXPERIMENT mixed numberofauthors temporal_rank i.yearsubmitted i.Njournal i.Nresearcharea TREATMENT if filterout !=1 & RETAIN ==1  & Excludegroup !=1 , cluster( studyid)
reg ex_sig196 EXPERIMENT mixed numberofauthors temporal_rank i.yearsubmitted i.Njournal i.Nresearcharea TREATMENT if filterout !=1 & RETAIN ==1 & Excludegroup !=1, cluster( studyid)
* Column (5)
reg tstat EXPERIMENT mixed numberofauthors temporal_rank i.yearsubmitted c.YEAR##i.Njournal i.Nresearcharea TREATMENT if filterout !=1 & RETAIN ==1  & Excludegroup !=1 , cluster( studyid)
reg ex_sig196 EXPERIMENT mixed numberofauthors temporal_rank i.yearsubmitted c.YEAR##i.Njournal i.Nresearcharea TREATMENT if filterout !=1 & RETAIN ==1  & Excludegroup !=1 , cluster( studyid)
* Panel B.	Allowing for anticipation effects, four-year post data-sharing window
**** with anticipation of policy
gen TREATMENTant = 0 
replace TREATMENTant = 1 if journaladoptingsharing =="The american economic review" & journal == "The american economic review" & yearsubmitted >= 2004
replace TREATMENTant = 1 if journaladoptingsharing =="Journal of political economy" & journal == "Journal of political economy" & yearsubmitted >= 2005
replace TREATMENTant = 1 if journaladoptingsharing =="The quarterly economic journal" & journal == "The quarterly journal of economics" & yearsubmitted >= 2015
replace TREATMENTant = 1 if journaladoptingsharing =="The quarterly journal of economics" & journal == "The quarterly journal of economics" & yearsubmitted >= 2015
replace TREATMENTant = 1 if journaladoptingsharing =="The review of economic studies" & journal == "The review of economic studies" & yearsubmitted >= 2009
replace TREATMENTant = 1 if journaladoptingsharing =="Econometrica" & journal == "Econometrica" & yearsubmitted >= 2003
replace TREATMENTant = 1 if journaladoptingsharing =="The review of economics and statistics" & journal == "The review of economics and statistics" & yearsubmitted >= 2009 
replace TREATMENTant = 1 if journaladoptingsharing =="European economic review" & journal == "European economic review" & yearsubmitted >= 2011 
replace TREATMENTant = 1 if journaladoptingsharing =="The economic journal" & journal == "The economic journal" & yearsubmitted >= 2011 
replace TREATMENTant = 1 if journaladoptingsharing =="Journal of the european economic association" & journal == "Journal of the european economic association"  & yearsubmitted >= 2010 
replace TREATMENTant = 1 if journaladoptingsharing =="Journal of development economics" & journal == "Journal of development economics"  & yearsubmitted >= 2013 
replace TREATMENTant = 1 if journaladoptingsharing =="Journal of money credit and banking" & journal == "Journal of money credit and banking" & yearsubmitted >= 1997 
replace TREATMENTant = 1 if journaladoptingsharing =="Journal of human resources" & journal == "Journal of human resources" & yearsubmitted >= 1989 
replace TREATMENTant = 1 if journaladoptingsharing =="Journal of labor economics" & journal == "Journal of labor economics" & yearsubmitted >= 2008 
* Column (1)
reg tstat TREATMENTant if filterout !=1 & RETAIN ==1  & Excludegroup !=1 , cluster( studyid)
reg ex_sig196 TREATMENTant if filterout !=1 & RETAIN ==1 & Excludegroup !=1, cluster( studyid)
* Column (2)
reg tstat i.yearsubmitted i.Njournal TREATMENTant if filterout !=1 & RETAIN ==1  & Excludegroup !=1 , cluster( studyid)
reg ex_sig196 i.yearsubmitted i.Njournal TREATMENTant if filterout !=1 & RETAIN ==1 & Excludegroup !=1, cluster( studyid)
* Column (3)
reg tstat i.yearsubmitted i.Njournal i.Nresearcharea TREATMENTant if filterout !=1 & RETAIN ==1  & Excludegroup !=1 , cluster( studyid)
reg ex_sig196 i.yearsubmitted i.Njournal i.Nresearcharea TREATMENTant if filterout !=1 & RETAIN ==1 & Excludegroup !=1, cluster( studyid)
* Column (4)
reg tstat EXPERIMENT mixed numberofauthors temporal_rank i.yearsubmitted i.Njournal i.Nresearcharea TREATMENTant if filterout !=1 & RETAIN ==1  & Excludegroup !=1 , cluster( studyid)
reg ex_sig196 EXPERIMENT mixed numberofauthors temporal_rank i.yearsubmitted i.Njournal i.Nresearcharea TREATMENTant if filterout !=1 & RETAIN ==1 & Excludegroup !=1, cluster( studyid)
* Column (5)
reg tstat EXPERIMENT mixed numberofauthors temporal_rank i.yearsubmitted c.YEAR##i.Njournal i.Nresearcharea TREATMENTant if filterout !=1 & RETAIN ==1  & Excludegroup !=1 , cluster( studyid)
reg ex_sig196 EXPERIMENT mixed numberofauthors temporal_rank i.yearsubmitted c.YEAR##i.Njournal i.Nresearcharea TREATMENTant if filterout !=1 & RETAIN ==1  & Excludegroup !=1 , cluster( studyid)
* Panel C. Sample weights, no policy anticipation
* Column (1)
reg tstat TREATMENT if filterout !=1 & RETAIN ==1  & Excludegroup !=1 [aweight = SAMPLE] , cluster( studyid)
reg ex_sig196 TREATMENT if filterout !=1 & RETAIN ==1  & Excludegroup !=1 [aweight = SAMPLE] , cluster( studyid)
* Column (2)
reg tstat i.yearsubmitted i.Njournal TREATMENT if filterout !=1 & RETAIN ==1  & Excludegroup !=1 [aweight = SAMPLE]  , cluster( studyid)
reg ex_sig196 i.yearsubmitted i.Njournal TREATMENT if filterout !=1 & RETAIN ==1  & Excludegroup !=1 [aweight = SAMPLE]  , cluster( studyid)
* Column (3)
reg tstat i.yearsubmitted i.Njournal i.Nresearcharea TREATMENT if filterout !=1 & RETAIN ==1  & Excludegroup !=1 [aweight = SAMPLE], cluster( studyid)
reg ex_sig196 i.yearsubmitted i.Njournal i.Nresearcharea TREATMENT if filterout !=1 & RETAIN ==1  & Excludegroup !=1 [aweight = SAMPLE], cluster( studyid)
* Column (4)
reg tstat EXPERIMENT mixed numberofauthors temporal_rank i.yearsubmitted i.Njournal i.Nresearcharea TREATMENT if filterout !=1 & RETAIN ==1  & Excludegroup !=1 [aweight = SAMPLE], cluster( studyid)
reg ex_sig196 EXPERIMENT mixed numberofauthors temporal_rank i.yearsubmitted i.Njournal i.Nresearcharea TREATMENT if filterout !=1 & RETAIN ==1  & Excludegroup !=1 [aweight = SAMPLE], cluster( studyid)
* Column (5)
reg tstat EXPERIMENT mixed numberofauthors temporal_rank i.yearsubmitted c.YEAR##i.Njournal i.Nresearcharea TREATMENT if filterout !=1 & RETAIN ==1  & Excludegroup !=1 [aweight = SAMPLE], cluster( studyid)
reg ex_sig196 EXPERIMENT mixed numberofauthors temporal_rank i.yearsubmitted c.YEAR##i.Njournal i.Nresearcharea TREATMENT if filterout !=1 & RETAIN ==1  & Excludegroup !=1 [aweight = SAMPLE], cluster( studyid)
* Panel D. Sample weights, with policy anticipation
* Column (1)
reg tstat TREATMENTant if filterout !=1 & RETAIN ==1  & Excludegroup !=1 [aweight = SAMPLE] , cluster( studyid)
reg ex_sig196 TREATMENTant if filterout !=1 & RETAIN ==1 & Excludegroup !=1 [aweight = SAMPLE], cluster( studyid)
* Column (2)
reg tstat i.yearsubmitted i.Njournal TREATMENTant if filterout !=1 & RETAIN ==1  & Excludegroup !=1 [aweight = SAMPLE], cluster( studyid)
reg ex_sig196 i.yearsubmitted i.Njournal TREATMENTant if filterout !=1 & RETAIN ==1 & Excludegroup !=1 [aweight = SAMPLE], cluster( studyid)
* Column (3)
reg tstat i.yearsubmitted i.Njournal i.Nresearcharea TREATMENTant if filterout !=1 & RETAIN ==1  & Excludegroup !=1 [aweight = SAMPLE], cluster( studyid)
reg ex_sig196 i.yearsubmitted i.Njournal i.Nresearcharea TREATMENTant if filterout !=1 & RETAIN ==1 & Excludegroup !=1 [aweight = SAMPLE], cluster( studyid)
* Column (4)
reg tstat EXPERIMENT mixed numberofauthors temporal_rank i.yearsubmitted i.Njournal i.Nresearcharea TREATMENTant if filterout !=1 & RETAIN ==1  & Excludegroup !=1 [aweight = SAMPLE], cluster( studyid)
reg ex_sig196 EXPERIMENT mixed numberofauthors temporal_rank i.yearsubmitted i.Njournal i.Nresearcharea TREATMENTant if filterout !=1 & RETAIN ==1 & Excludegroup !=1 [aweight = SAMPLE], cluster( studyid)
* Column (5)
reg tstat EXPERIMENT mixed numberofauthors temporal_rank i.yearsubmitted c.YEAR##i.Njournal i.Nresearcharea TREATMENTant if filterout !=1 & RETAIN ==1  & Excludegroup !=1 [aweight = SAMPLE], cluster( studyid)
reg ex_sig196 EXPERIMENT mixed numberofauthors temporal_rank i.yearsubmitted c.YEAR##i.Njournal i.Nresearcharea TREATMENTant if filterout !=1 & RETAIN ==1  & Excludegroup !=1 [aweight = SAMPLE], cluster( studyid)


*** Density plots of falsification tests
*** Figures S3 to S6 are produced by the commands listed above under "SECTION 5.3, FALSIFICATION TESTS" 

*** General equilibrium effects
*** FIGURE S7	New submissions to The American Economic Review and Econometrica
**Use data in the file 'New submissions AER.dta'

*** FIGURE S8	Data-sharing journals, median share of estimates, by research area bias.
*** Use data in the file 'Selection bias.dta'
scatter changeshare absbias if absbias  < 1
scatter changeshare absbias if absbias >=1 & absbias <=2
scatter changeshare absbias if absbias >2 & changeshare !=.

*** FIGURES S9 and S10 use data from: 'Stacked Data 30 Aug.dta' 
** Figure S9: Distribution of t-values among ‘control’ (never treated) journals
twoway (kdensity tstat if RETAINPOST == 1 & EVENT == 0 & tstat < 10) (kdensity tstat if RETAINPRE == 1 & EVENT == 0 & tstat < 10)
sum tstat if RETAINPOST == 1 & EVENT == 0
sum tstat if RETAINPRE == 1 & EVENT == 0 
** Figure S10: Distribution of excess statistical significance among ‘control’ (never treated) journals
// graph for control journals only (no data-sharing ever), pre-data-sharing and post-data-sharing; to check for spillovers
twoway (kdensity ex_sig196 if RETAINPOST == 1 & EVENT == 0 & ex_sig196 > 0) (kdensity ex_sig196 if RETAINPRE == 1 & EVENT == 0 & ex_sig196 > 0)
sum ex_sig196 if RETAINPOST == 1 & EVENT == 0
sum ex_sig196 if RETAINPRE == 1 & EVENT == 0 

*** TABLE S11 Mandatory Data-sharing and Publication Bias
*** share is the change in the share of estimates published by data-sharing journals pre- and post-data-sharing
gen share100 = share *100
** Column (1) Share of all research areas
reg share100 sharing , robust
*** Column (2) modest selectivity areas
reg share100 sharing if bias < 1
*** Column (3) substantial selectivity areas
reg share100 sharing if bias >=1 & bias <=2
*** Column (4) severe selectivity areas
reg share100 sharing if bias >=2

*** TABLE S12 Number of estimates pre- and post-data-sharing
sum tstat if journal == "The american economic review" & INTERVENTION ==0
sum tstat if journal == "The american economic review" & INTERVENTION ==1
sum tstat if journal == "Journal of political economy" & INTERVENTION ==0
sum tstat if journal == "Journal of political economy" & INTERVENTION ==1
sum tstat if journal == "The quarterly journal of economics" & INTERVENTION ==0
sum tstat if journal == "The quarterly journal of economics" & INTERVENTION ==1
sum tstat if journal == "The review of economic studies"  & INTERVENTION ==0
sum tstat if journal == "The review of economic studies"  & INTERVENTION ==1
sum tstat if journal == "Econometrica"  & INTERVENTION ==0
sum tstat if journal == "Econometrica"  & INTERVENTION ==1
sum tstat if journal == "The review of economics and statistics"  & INTERVENTION ==0
sum tstat if journal == "The review of economics and statistics"  & INTERVENTION ==1
sum tstat if journal ==  "European economic review"  & INTERVENTION ==0
sum tstat if journal ==  "European economic review"  & INTERVENTION ==1
sum tstat if journal ==  "The economic journal"  & INTERVENTION ==0
sum tstat if journal ==  "The economic journal"  & INTERVENTION ==1
sum tstat if journal ==  "Journal of the european economic association"  & INTERVENTION ==0
sum tstat if journal ==  "Journal of the european economic association"  & INTERVENTION ==1
sum tstat if journal ==  "Journal of development economics" & INTERVENTION ==0
sum tstat if journal ==  "Journal of development economics"  & INTERVENTION ==1
sum tstat if journal ==  "Journal of money credit and banking" & INTERVENTION ==0
sum tstat if journal ==  "Journal of money credit and banking" & INTERVENTION ==1
sum tstat if journal ==  "Journal of human resources" & INTERVENTION ==0
sum tstat if journal ==  "Journal of human resources" & INTERVENTION ==1
sum tstat if journal ==  "Journal of labor economics" & INTERVENTION ==0
sum tstat if journal ==  "Journal of labor economics" & INTERVENTION ==1

**********************************************************************************************************************************************************************************************

