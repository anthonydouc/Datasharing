# -*- coding: utf-8 -*-
from poweranalysis import run_local, read_top31

'''
Running this script will run the analysis using three different methods:
    - wls (weighted least squares).
    - rfe (random effects).
    - fpp (fat pet peese).

By default data from all journals is included, and outliers and 
leverage points removed. To explore the impact of these assumptions,
two additional analyses are conducted:
    - retaining all data points, including those classified as outliers or leverage points.
    - using only data points from the top 31 journals (but removing outliers & leverage points).

Prior to running, ensure that all data is saved in the following location:
`Poweranalysis/data/group1`.

For all methods, outputs will be saved in the `Poweranalyis/outputs` folder.
'''

if __name__ == '__main__':
    
    top31 = read_top31()

    methods = ['wls', 'rfe', 'fpp', 'wls', 'wls']
    
    drop_outliers = [True, True, True, False, True]
    
    keep_journal = [None, None, None, None, top31]
    
    for method, drop_outlier, keep_journal in zip(methods, drop_outliers, keep_journal):
        run_local(method, drop_outlier, keep_journal, suffix='test')
