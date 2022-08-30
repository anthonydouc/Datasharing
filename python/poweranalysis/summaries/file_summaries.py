# -*- coding: utf-8 -*-
'''
Module for generating research area level summary files.
'''
import pandas as pd

from ..analysis import read_top31, filter_for_file_stats
from ..paths import get_info_dir, get_save_dir


def data_sharing_compar(all_data:pd.DataFrame, infodir: str):
    '''
    Generates a stacked dataset by iteratively removing
    data from individual research areas.
    '''

    top31 = read_top31()

    all_data_31 = all_data[all_data['Journal'].isin(top31)]

    data = []

    sharing_exclusions = pd.read_excel(f'{infodir}/data_sharing_exclusions.xlsx')
    sharing_exclusions.columns = [col.capitalize() for col in sharing_exclusions.columns]
    sharing_exclusions['Journals_excluded'] = sharing_exclusions['Journals_excluded'].str.capitalize()
    sharing_exclusions = sharing_exclusions.set_index('Journals_excluded')

    for col in sharing_exclusions.columns:
        exclude_journals = sharing_exclusions[sharing_exclusions[col] == 1].index
        sharing_data = all_data_31[~all_data_31['Journal'].isin(exclude_journals)].copy()
        sharing_data['Journal adopting sharing'] = col
        data.append(sharing_data)

    all_data = pd.concat(data)
    return all_data


def data_sharing_prop(reg_results: pd.DataFrame,
                      data_sharing_summary: pd.DataFrame) -> pd.DataFrame:

    summary = reg_results.copy()
    summary['Median_share_before_data_sharing'] = data_sharing_summary['Before_data_sharing']['Median']
    summary['Median_share_after_data_sharing'] = data_sharing_summary['After_data_sharing']['Median']
    return summary


def data_sharing_summaries(output_dir, how, suffix, all_data, reg_results):
    '''
    Generates research area (file) summary files relating to data sharing
    only, and saves to disk.
    '''

    all_data = filter_for_file_stats(all_data)

    infodir = get_info_dir()

    savedir = get_save_dir(output_dir, f'{how}{suffix}/file_summaries/')

    save_kwargs = {'encoding':'latin-1'}

    sharing_compar = data_sharing_compar(all_data, infodir)

    (sharing_compar
     .reset_index()
     .to_excel(f'{savedir}/data_sharing_comparison.xlsx', **save_kwargs))
