# -*- coding: utf-8 -*-
from poweranalysis import run_local

'''
Running this script will run the analysis using four different methods:
- wls (weighted least squares)
- rfe (random effects)
- ols (ordinary least squares)
- fpp (fat pet peese).

Prior to running, ensure that all data is saved in the following location:
`Poweranalysis/data/group1`.

For all methods, outputs will be saved in the `Poweranalyis/outputs` folder.
'''

if __name__ == '__main__':

    methods = ['wls', 'rfe', 'ols', 'fpp']

    for method in methods:
        run_local(method, suffix='test')
