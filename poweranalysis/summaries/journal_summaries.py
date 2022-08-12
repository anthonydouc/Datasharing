# -*- coding: utf-8 -*-
'''
Module for generating journal level summary files.
'''
import pandas as pd

from ..analysis import read_top31, filter_for_journal_stats

from ..paths import get_save_dir


def generate_subset(all_data: pd.DataFrame, journals: list) -> pd.DataFrame:
    '''
    Generates substets of the data file where estimates are published in
    the list of specified journals.
    '''

    data_sub = all_data[all_data['Journal'].isin(journals)]

    data_sub['No. obs year'] = (data_sub
                                .groupby('Year published')
                                .transform('count')['Obs id'])

    data_sub['No. obs journal'] = (all_data
                                   .groupby(['Year published', 'Journal'])
                                   .transform('count')['Obs id'])

    data_sub['Share'] = (data_sub['No. obs journal']
                         / data_sub['No. obs year'])

    return data_sub


def get_journal_files(all_data, journals):

    data_journals = all_data[all_data['Journal'].isin(journals)]

    files_sub = data_journals['Filename'].unique()

    return files_sub


def generate_subset_files(all_data: pd.DataFrame, journals: list) -> pd.DataFrame:
    '''
    Generates substets of the data file where files are ....
    '''

    files_sub = get_journal_files(all_data, journals)

    data_sub = all_data[all_data['Filename'].isin(files_sub)]

    return data_sub


def journal_data_subsets(output_dir: list, how: str, suffix: str,
                         all_data: pd.DataFrame):
    '''
    Generates substets of the data file for labour and top31 journals,
    and saves to disk.
    '''

    save_dir = get_save_dir(output_dir, f'{how}{suffix}/')

    save_kwargs = {'encoding':'latin-1'}

    top31_journals = read_top31()

    all_data_flt = filter_for_journal_stats(all_data)

    m_out = all_data_flt['Outlier'] == False
    m_lev = all_data_flt['Leverage_point'] == False

    all_data_flt = all_data_flt[m_out & m_lev]

    # top 31 journals
    data_31 = generate_subset(all_data_flt, top31_journals)

    data_31.to_excel(f'{save_dir}/estimate_data_31only.xlsx', **save_kwargs)
