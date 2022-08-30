# -*- coding: utf-8 -*-
''' Module for reading and processing raw data. '''

import os

import numpy as np
import pandas as pd

from .author_network import assign_author_groups
from .editor_analysis import map_editors, editor_changes
from .lookups import (get_journal_reps_contains, get_journal_reps,
                      get_author_reps, get_journal_reps_partial,
                      get_journal_attrs)


def read_data(filename: str) -> pd.DataFrame:
    ''' Reads data for a single study area from file. '''
    data = pd.read_excel(filename, sheet_name='Data')
    data = data.dropna(how='all')
    return data


def check_data_cols(data: pd.DataFrame) -> pd.DataFrame:
    '''
    Ensures data for each study area contains the same column names,
    even if all values are empty.
    '''

    authorcolumns = [f'Author {x}' for x in range(1, 10)]

    savecolumns = ['Standard error', 'Effect size', 'Journal', 'Filter',
                   'Study no.', 'Filename', 'Number of authors', 'Sample size',
                   'Year published', 'Submission year', 'Submission date',
                   'Acceptance date', 'Author share of estimates',
                   'Google scholar citations may 2021', 'Title',  'Doi',
                   'Data available'] + authorcolumns

    if ('journal' in data.columns) and ('Journal' in data.columns):
        data = data.drop('journal', axis=1)

    columns = data.columns

    newcols = []

    for col in columns:
        if type(col) == str:
            col = col.replace('  ','').rstrip().capitalize()
        newcols.append(col)

    data.columns = newcols


    # ensure that data contains a filter column if not present in raw data.
    if 'Filter' not in data.columns:
        data['Filter'] = 1

    # ensure that column is included in dataframe if not in raw data
    check_columns = [col for col in savecolumns if col != 'Filter']

    for col in check_columns:
        if col not in data.columns:
            data[col] = np.nan

    data = data[savecolumns]

    drop_cols = [c for c in data.columns if c not in ['Filename','Filter']]
    data = data.dropna(how='all', subset=drop_cols)

    return data


def compile_data(readdir:str, keep_journals: list=None, drop_for: list=None,
                 min_tstat:float=None) -> pd.DataFrame:
    ''' Compiles all data into a single consistent dataframe. '''

    all_data = []

    files = get_dir_files(readdir)

    for file in files:
        data = read_data(f'{readdir}{file}')

        data['Filename'] = file

        data = check_data_cols(data)

        all_data.append(data)

    data = pd.concat(all_data)

    return data


def author_reps(data: pd.DataFrame) -> pd.DataFrame:
    ''' Standardises author name format. '''

    author_full_replace = get_author_reps()

    authorcolumns = [f'Author {x}' for x in range(1, 10)]

    for acol in authorcolumns:
        data[acol] = (data[acol]
                      .fillna('')
                      .astype(str)
                      .str.rstrip()
                      .str.lstrip()
                      .str.capitalize())

        data[acol] = (data[acol]
                      .map(author_full_replace)
                      .fillna(data[acol])
                      .astype(str)
                      .str.lstrip()
                      .str.rstrip()
                      .str.capitalize())

    return data


def journal_reps(data: pd.DataFrame) -> pd.DataFrame:
    ''' Standardises journal name format. '''

    journal_full_replace = get_journal_reps()

    journal_reps_partial = get_journal_reps_partial()

    journal_reps_contains = get_journal_reps_contains()

    data['Journal'] = (data['Journal']
                       .fillna('')
                       .astype(str)
                       .str.lstrip()
                       .str.rstrip()
                       .str.capitalize())

    for s,r in journal_reps_contains.items():
        mask_isin = data['Journal'].str.contains(s, case=False)
        data.loc[mask_isin, 'Journal'] = r

    for s,r in journal_reps_partial.items():
        data['Journal'] = (data['Journal']
                           .str.replace(s, r, case=False, regex=True)
                           .str.capitalize())

    data['Journal'] = (data['Journal']
                       .map(journal_full_replace)
                       .fillna(data['Journal'])
                       .astype(str)
                       .str.lstrip()
                       .str.rstrip()
                       .str.capitalize())

    data['Journal'] = data['Journal'].fillna('None')

    return data


def effect_size_reps(data: pd.DataFrame) -> pd.DataFrame:
    ''' Standardises effect size format. '''

    es_reps = ['???', 'n.a.', 'na', '.', '—']

    for es_rep in es_reps:
        data['Effect size'] = data['Effect size'].replace(es_rep, np.nan)

    data['Effect size'] = data['Effect size'].astype(float)

    return data


def standard_error_reps(data: pd.DataFrame) -> pd.DataFrame:
    ''' Standardises standard error format. '''

    se_reps = ['.', 'n.a.', ' ']

    for se_rep in se_reps:
        data['Standard error'] = data['Standard error'].replace(se_rep, np.nan)

    data['Standard error'] = data['Standard error'].astype(float)

    return data


def sample_size_reps(data: pd.DataFrame) -> pd.DataFrame:
    ''' Standardises sample size format. '''

    ss_reps = ['code', 'na', '???', '??', '?', '.']

    for ss_rep in ss_reps:
        data['Sample size'] = data['Sample size'].replace(ss_rep, np.nan)

    if data['Sample size'].dtype != 'float64':
        data.loc[data['Sample size']=='22-24', 'Sample size'] = 23
        data.loc[data['Sample size']=='ommitted', 'Sample size'] = 23

    data['Sample size'] = data['Sample size'].astype(float)

    return data


def year_reps(data: pd.DataFrame) -> pd.DataFrame:
    ''' Standardises year published and submission year format. '''

    year_fields = ['Year published', 'Submission year']

    rep_values = ['nan', 'na', 'a', 'b', 'c', 'd', 'e', 'Unkown']

    for field in year_fields:
        data[field] = data[field].astype(str)

        for rep in rep_values:
            data[field] = data[field].str.replace(rep,'')

        data[field] = data[field].replace('', np.nan)

        data[field] = data[field].astype(float)

    return data


def avail_reps(data: pd.DataFrame) -> pd.DataFrame:
    ''' Standardises data available format. '''

    data['Data available'] = data['Data available'].str.capitalize()

    mask_dataav = data['Data available'] == 'Yes'

    data.loc[mask_dataav, 'Data available'] = 1

    data.loc[~mask_dataav, 'Data available'] = 0

    return data


def clean_data(data: pd.DataFrame) -> pd.DataFrame:
    ''' Standardises the format of key data fields. '''

    data = author_reps(data)

    data = journal_reps(data)

    data = effect_size_reps(data)

    data = standard_error_reps(data)

    data = sample_size_reps(data)

    data = year_reps(data)

    data = avail_reps(data)

    return data


def assign_acceptance_time(data: pd.DataFrame) -> pd.DataFrame:

    date_fields = ['Acceptance date', 'Submission date']

    formats = ['%Y-%d-%m', '%Y-%m-%d', '%B %d %Y', '%B %Y']

    for date_field in date_fields:
        data[date_field] = (data[date_field].astype(str)
                            .replace('na', np.nan)
                            .str.replace(',', '')
                            .str.replace('.', ''))

    data['Acceptance date parsed'] = pd.NaT

    data['Submission date parsed'] = pd.NaT

    for date_field in date_fields:

        fld_parsed = f'{date_field} parsed'

        for fmt in formats:
            mnull = ((data[date_field].notnull())
                     & (data[fld_parsed].isnull()))

            data.loc[mnull, fld_parsed] = pd.to_datetime(data.loc[mnull, date_field],
                                                  format=fmt,
                                                  exact=True,
                                                  errors='coerce')

            data.loc[mnull, fld_parsed] = pd.to_datetime(data.loc[mnull, fld_parsed],
                                                         format='%Y-%d-%m',
                                                         errors='coerce')

    data['Acceptance date'] = data['Acceptance date parsed']

    data['Submission date'] = data['Submission date parsed']

    data['Acceptance_time_days'] = (data['Acceptance date'] - data['Submission date']).dt.days

    data['Acceptance_time_weeks'] = data['Acceptance_time_days'] / 7

    data = data.drop(['Acceptance date parsed', 'Submission date parsed'], axis=1)

    return data


def determine_invalid_est(data: pd.DataFrame) -> pd.DataFrame:
    ''' Flags individual studies with invalid effect sizes. '''

    data['Est_invalid'] = True
    mask_esnull = data['Effect size'].notnull()
    data.loc[mask_esnull, 'Est_invalid'] = False
    return data


def determine_invalid_se(data: pd.DataFrame) -> pd.DataFrame:
    ''' Flags individual studies with invalid standard errors. '''

    data['SE_invalid'] = True
    mask_se = data['Standard error'] > 0
    mask_senull = data['Standard error'].notnull()
    data.loc[(mask_se & mask_senull), 'SE_invalid'] = False
    return data


def determine_invalid_journal(data: pd.DataFrame) -> pd.DataFrame:
    ''' Flags individual studies with invalid journal names. '''

    data['Journ_invalid'] = True
    mask_journinv = ((data['Journal'].notnull())
                      & (data['Journal'] != '')
                      & (data['Journal'] != 'None'))
    data.loc[mask_journinv, 'Journ_invalid'] = False
    return data


def determinate_invalid_year(data: pd.DataFrame) -> pd.DataFrame:
    ''' Flags individual studies with invalid publication year. '''

    data['Year_pub_invalid'] = True
    mask_yearinv = ((data['Year published'].notnull())
                     & (data['Year published'] != -1))
    data.loc[mask_yearinv, 'Year_pub_invalid'] = False
    return data


def filter_data(data, keep_journals: list=None, drop_for: list=None,
                min_tstat: float=None):
    '''
    Filters data based on optionall, specified journals, FOR codes
    or minimum t-stat.
    '''

    if keep_journals is not None:
        data = data[data['Journal'].isin(keep_journals)]
    if drop_for is not None:
        data = data[~(data['FoR code'].isin(drop_for)|data['FoR code'].isnull())]
    if min_tstat is not None:
        data = data[data['t-stat'] >= min_tstat]
    return data


def get_dir_files(dirname: str) -> list:
    ''' Gets all filenames stored in the specified directory. '''

    all_files = os.listdir(dirname)

    files = [file for file in all_files
             if '.xlsx' in file and '~' not in file]

    return files


def assign_journal_attrs(data: pd.DataFrame) -> pd.DataFrame:
    ''' Assigns journal information to each study.'''

    rankings, forcodes = get_journal_attrs()

    data['Ranking'] = data['Journal'].map(rankings)

    data['FoR code'] = data['Journal'].map(forcodes)

    return data


def calc_tstat(data):
    ''' Calculates the t-statistic for each study. '''
    data['t-stat'] = abs(data['Effect size']) / data['Standard error']
    return data


def calc_year_submit(data):
    ''' Fills in missing values for the year submitted. '''

    m_null = data['Submission year'].isnull()

    m_neg = data['Submission year'] <= 0

    data.loc[m_null | m_neg, 'Submission year'] = data.loc[m_null | m_neg, 'Year published'] - 2

    data = data.rename(columns={'Submission year': 'yearsubmitted'})

    return data


def assign_study_fields(data: pd.DataFrame) -> pd.DataFrame:
    ''' Assigns study number related fields. '''

    mask_sno_null = data['Study no.'].isnull()

    data.loc[mask_sno_null, 'Study no.'] = data['Study no.'].max() + 1

    data['Study id.'] = 1 + data.groupby(['Study no.','Filename']).ngroup()
    return data


def assign_time_fields(data: pd.DataFrame) -> pd.DataFrame:
    ''' Assigns date related fields. '''

    # First and last year before all filtering.
    data['First year'] = (data
                          .groupby('Filename')['Year published']
                          .transform('min'))

    data['Last year'] = (data
                         .groupby('Filename')['Year published']
                         .transform('max'))

    data['Time span'] = data['First year'] - data['Last year']

    data['temporal_rank'] = (data
                             .groupby('Filename')['Year published']
                             .rank(method='dense'))

    data['Year published'] = data['Year published'].fillna(-1)

    return data



def pre_process_data(data: pd.DataFrame) -> pd.DataFrame:
    ''' Processes compiled data prior to filtering. '''

    # assigns relevant time fields, excluding submission and acceptance years.
    data = assign_time_fields(data)

    # assigns submission and acceptance year fields.
    data = assign_acceptance_time(data)

    # asssign journal specific attributes to data.
    data = assign_journal_attrs(data)

    # calculate tstatistic at the raw study level.
    data = calc_tstat(data)

    return data


def post_process_data(data: pd.DataFrame) -> pd.DataFrame:
    ''' Processes compiled data to include calculated fields. '''

    # assigns study number fields.
    data = assign_study_fields(data)

    # determine entries with invalid standard errors.
    data = determine_invalid_se(data)

    # determine entries with invalid estimates.
    data = determine_invalid_est(data)

    # determine entries with invalid journal names.
    data = determine_invalid_journal(data)

    # determine entries with invalid publication years.
    data = determinate_invalid_year(data)

    # assign new year submit year.
    data = calc_year_submit(data)

    # assign author groups based on network analysis.
    data = assign_author_groups(data)

    data = data.reset_index()

    # assign editors to data.
    data = map_editors(data)

    # calculates the number of editors.
    data = editor_changes(data)

    return data


def get_all_data(readdir: str='../data/group1/', keep_journals: list=None,
                 drop_for: list=None, min_tstat:float=None) -> pd.DataFrame:
    '''
    Reads in all available data, and performs the following operations:
        1. Standardises the format of all key variables.
        2. Calculates various fields and maps these onto the original data
           (prior to filtering).
        3. Removes data based on optionally specified filters.
        4. Assign a unique identifier to each study after filtering.
        5. Calculates various fields and maps these onto the original data
           (after filtering).
    '''

    data = compile_data(readdir, keep_journals, drop_for, min_tstat)

    data = clean_data(data)

    data = pre_process_data(data)

    data = filter_data(data,
                       keep_journals=keep_journals,
                       drop_for=drop_for,
                       min_tstat=min_tstat)

    data = data.reset_index(drop=True)

    data.index.names = ['Obs id']

    data = post_process_data(data)

    data = data.sort_index().reset_index()

    return data


def get_data_fin(keep_journals):

    data = pd.read_excel('../data/group1/All Data.xlsx')
    
    data = filter_data(data, keep_journals)
    
    return data
