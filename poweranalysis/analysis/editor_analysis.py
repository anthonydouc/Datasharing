# -*- coding: utf-8 -*-
'''
Module for analysis and processing of editors.
'''

import numpy as np
import pandas as pd

from .lookups import read_editors


def map_editors(data: pd.DataFrame) -> pd.DataFrame:
    '''
    Determines the editors and coeditors for each effect based on
    the journal its published in, and the editors & coeditors active in
    that journal at the year of submission.
    '''

    editors = read_editors()

    etypes = ['Editor', 'Co-editor']

    for etype in etypes:

        editor_data = editors[editors['Editor_type'] == etype]

        data_merge = data[['Journal', 'yearsubmitted', 'Obs id']]

        data_merge = data_merge.merge(editor_data, how='left', on=['Journal'])

        mask_lower = data_merge['yearsubmitted'] >= data_merge['Year_commenced']

        mask_higher = data_merge['yearsubmitted'] <= data_merge['Year_ended']

        data_merge = data_merge[mask_lower & mask_higher]

        data_merge = data_merge[['Obs id','Name']]

        data_merge['Editor_number'] = data_merge.groupby('Obs id').cumcount()

        data_merge = data_merge.set_index(['Obs id', 'Editor_number'])

        data_merge = data_merge.unstack(1)

        data_merge.columns = [etype + '_' + str(col[1]) for col in data_merge.columns]

        data = data.merge(data_merge, on=['Obs id'], how='left')

    return data


def editor_changes(data: pd.DataFrame) -> pd.DataFrame:
    '''
    Determines the change in the number of unique editors & co-editors
    from year to year (Within the same journal).
    '''

    editor_cols = [col for col in data.columns
                   if ('Co-editor' in col) or ('Editor' in col)]

    data = data.sort_values(by=['Journal', 'yearsubmitted'], ascending=True)

    # List of unique editors for each effect
    data['Unique editors'] = data[editor_cols].apply(lambda row: list(row.dropna().unique()), axis=1)

    data['Number of unique editors'] = data['Unique editors'].map(len)

    # List of unique editors in the previous year
    data['Editors shifted'] = (data
                               .groupby('Journal')['Unique editors']
                               .shift())

    data['Editors shifted'] = (data
                               .groupby('Journal')['Editors shifted']
                               .fillna(method='bfill')
                               .fillna("")
                               .apply(list))
    
    # Number of new editors
    data['New editors'] = (data['Unique editors'].apply(set)
                           - data['Editors shifted'].apply(set))

    # Number of editors lost
    data['Lost editors'] = (data['Editors shifted'].apply(set)
                            - data['Unique editors'].apply(set))

    data['No. new editors'] = (data['New editors']
                               .apply(len)
                               .replace(0, np.nan))
    
    data['No. lost editors'] = (data['Lost editors']
                                .apply(len)
                                .replace(0, np.nan))

    # Set missing values to zero on a journal by journal basis.
    data['No. new editors'] = (data
                               .groupby(['Journal', 'yearsubmitted'])['No. new editors']
                               .fillna(method='ffill')
                               .fillna(0))

    data['No. lost editors'] = (data
                                .groupby(['Journal', 'yearsubmitted'])['No. lost editors']
                                .fillna(method='ffill')
                                .fillna(0))

    data['Net change in unique editors'] = (data['No. new editors']
                                            - data['No. lost editors'])

    data['Prop. new editors'] = (data['No. new editors']
                                 / data['Number of unique editors'] * 100)

    data = data.drop(['Editors shifted', 'New editors', 'Lost editors'], axis=1)

    data = data.sort_values(by=['Filename', 'Study id.'], ascending=True)

    return data
