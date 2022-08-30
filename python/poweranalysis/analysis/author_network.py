# -*- coding: utf-8 -*-
'''
Module for network analysis of authors.
'''

import networkx as nx
import pandas as pd

from .filtering import filter_for_network


def assign_author_groups(all_data: pd.DataFrame) -> pd.DataFrame:
    '''
    Determines connected groups of authors based on their collaboration on
    publications within each research area.
    '''

    author_cols = [f'Author {x}' for x in range(1,10)]

    all_data_flt = filter_for_network(all_data)

    data = pd.melt(all_data_flt, id_vars=['Filename','Study id.'],
                   value_vars=author_cols, value_name='Author')

    data = data.drop_duplicates(subset=['Filename', 'Study id.', 'Author'])

    mask_nnull = ~data['Author'].isnull()

    mask_nempty = data['Author'] != ''

    data = data[mask_nempty & mask_nnull]

    filenames = data['Filename'].unique()

    groups = {}

    n = 0

    for filename in filenames:

        data_file = data[data['Filename']==filename][['Filename','Study id.','Author']]

        data_file['Val'] = 1

        dfs = pd.pivot_table(data_file, index='Author', columns=['Study id.'], values=['Val'])['Val'].fillna(0)

        dfs = dfs.stack()

        dfs = dfs[dfs==1]

        edges = dfs.index.to_list()

        G = nx.Graph(edges)

        l = list(nx.connected_components(G))

        L = [dict.fromkeys(y,x) for x,y in enumerate(l)]

        groups = {**groups, **{k: v + n for d in L for k, v in d.items()}}

        n += len(l)

    all_data['Author group'] = all_data['Study id.'].map(groups)
    
    all_data_flt['Author group'] = all_data_flt['Study id.'].map(groups)

    nest_file = (all_data_flt
                 .groupby('Filename')['Study id.']
                 .count()
                 .to_dict())
    
    nest_agroup = (all_data_flt
                   .groupby(['Author group'])['Study id.']
                   .count()
                   .to_dict())

    all_data['No. estimates file'] = all_data['Filename'].map(nest_file)
    
    all_data['No. estimates author group'] = all_data['Author group'].map(nest_agroup)
    
    all_data['Author group share of estimates'] = (all_data['No. estimates author group']
                                                   / all_data['No. estimates file'])

    return all_data
