# -*- coding: utf-8 -*-
'''
Module for reading various types of data from file or dictionaries.
'''

import numpy as np
import pandas as pd

from ..paths import get_info_dir

infodir = get_info_dir()


def read_editors() -> pd.DataFrame:
    ''' Reads in data containing list of editors and their attributes. '''
    
    editors = pd.read_excel(f'{infodir}/Editors in top 31.xlsx')

    editors['Journal'] = (editors['Journal']
                          .str.capitalize()
                          .str.lstrip()
                          .str.rstrip())

    editors['Year_commenced'] = (editors['Year_commenced']
                                 .replace('*','')
                                 .replace('', np.nan)
                                 .astype(float))

    editors['Year_ended'] = (editors['Year_ended']
                             .replace('*','')
                             .replace('', np.nan)
                             .astype(float))
    return editors


def read_labour_journals() -> list:
    ''' Reads in data containing a list of labour economics journals. '''
    
    journals = pd.read_csv(f'{infodir}/Labour Journals.csv')['Title'].values
    journals = [j.capitalize() for j in journals]
    
    return journals


def read_top31() -> list:
    ''' Reads in data containing a list of the top 31 journals. '''
    
    top_31_journals = pd.read_excel(f'{infodir}/top 31.xlsx')['Journal']
    top_31_journals = [j.capitalize() for j in top_31_journals.values]
    
    return top_31_journals


def read_top31order() -> list:
            
    top31_info = pd.read_excel(f'{infodir}/top 31.xlsx')
    top31_info['Journal'] = top31_info['Journal'].str.capitalize()
    top31order = top31_info.set_index('Journal')['Reporting_order'].to_dict()
    
    return top31order


def read_top5() -> list:
    ''' Returns a list of the top 5 Journals. '''
    
    top5 = ['The american economic review',
            'Econometrica',
            'Journal of political economy',
            'The quarterly journal of economics',
            'The review of economic studies']
    
    return top5


def get_impact_factors() -> dict:
    ''' Reads in journal impact factors. '''
    
    info_dir = get_info_dir()
    
    replacements = get_journal_reps_partial()
    
    impact_factors = pd.read_csv(f'{info_dir}/JournalHomeGrid.csv', encoding='latin-1')
    
    impact_factors['Full Journal Title'] = (impact_factors['Full Journal Title']
                                            .str.capitalize()
                                            .replace('  ',' ')
                                            .str.replace('&','and'))
        
    for s,r in replacements.items():
        impact_factors['Full Journal Title'] = (impact_factors['Full Journal Title']
                                                .str.replace(s, r, case=False)
                                                .str.capitalize())
            
    journal_factors = dict(zip(impact_factors['Full Journal Title'], impact_factors['Journal Impact Factor']))
    
    return journal_factors


def get_journal_attrs() -> (dict, dict):
    ''' Assigns journal information to each study.'''


    journal_ranking = pd.read_csv(f'{infodir}/journal_quality_ranking.csv', encoding='latin-1')

    journal_ranking['Journal name'] = (journal_ranking['Journal name']
                                       .str.capitalize()
                                       .replace('  ',' '))

    rankings = dict(zip(journal_ranking['Journal name'],
                        journal_ranking['ABDC List 2013']))

    forcodes = dict(zip(journal_ranking['Journal name'],
                        journal_ranking['FoR code']))

    return rankings, forcodes


def get_author_reps() -> dict:
    ''' Reads in string replacements for author names. '''
    
    reps = pd.read_excel(f'{infodir}/author_replacements.xlsx',
                          index_col='Original entry')['New entry']
    
    reps = reps.str.capitalize()
    
    reps.index = (reps
                  .index
                  .str.capitalize())

    return reps.to_dict()


def get_journal_reps() -> dict:
    ''' Reads in string replacement for journal names. '''
    
    reps = pd.read_excel(f'{infodir}/journal_replacements.xlsx',
                         index_col='Original entry')['New entry']

    reps = reps.str.capitalize()
    
    reps.index = (reps
                  .index
                  .str.capitalize())
    
    return reps.to_dict()


def get_study_type() -> dict:
    
    meta_data = pd.read_excel(f'{infodir}/Meta-Studies Included 16 Feb 2020.xlsx', encoding='latin-1')

    meta_data['File Name'] = (meta_data['File Name']
                              .fillna('')
                              .str.replace('xslx','xlsx')
                              .str.replace('â€™','’')
                              .str.replace('Ä±','ı')
                              .str.replace('Ã¡','á'))
    
    m_xlsx = ~meta_data['File Name'].str.contains('.xlsx')
    
    meta_data.loc[m_xlsx, 'File Name'] = meta_data.loc[m_xlsx, 'File Name'] +'.xlsx'
    
    effects = dict(zip(meta_data['File Name'], meta_data['Effect size']))
    
    types = dict(zip(meta_data['File Name'], meta_data['Micro or Macro']))

    return effects, types


def get_journal_reps_partial() -> dict:
    '''
    Returns partial replacements for journal names that contain any of the
    dictionary keys values.
    '''
    
    reps = {',': '',
            '  ': '',
            '\n': ' ',
            ' & ': ' and ',
            '& ': 'and ',
            ' &': ' and',
            '&': ' and ',
            '’': '',
            'quaterly': 'quarterly',
            'jounrnal': 'journal',
            'Agricutural': 'Agricultural',
            'eonomics': 'economics',
            'econmy': 'economy',
            "ecohomics": "economics",
            'reginal': 'regional',
            'finanical': 'financial',
            'economicss': 'economics',
            'quartrely': 'quarterly',
            'Woking': 'Working',
            'staudies': 'studies',
            'The the': 'the',
            'tansition': 'transition',
            'polcy': 'policy',
            'Jorunal': 'Journal',
            'jurnal':'journal',
            'Jounal':'journal',
            'enegy':'energy',
            'inovative': 'innovative',
            'the the': 'the',
            'mangement': 'management',
            'qauntity': 'quantity',
            'quartly': 'quarterly',
            'rsearchand': 'research and',
            'Enterpreneurship': 'Entrepreneurship',
            'Intermtional': 'International',
            'econmics': 'economics',
            'InternaÂ­tional': 'International',
            'InterÂ­national': 'International',
            ' od ': ' of ',
            'jounrnal': 'journal',
            'plannning': 'planing',
            'pacfic': 'pacific',
            'Â': '',
            'Ã': '',
            '\xa0': ' ',
            'financejournal': 'finance journal',
            'journal finance': 'journal of finance',
            'planningand': 'planning and',
            'if peace': 'of peace',
            'manageÂ­ment': 'Management',
            'EuÂ­ropean': 'European',
            'enviromental': 'environmental',
            'researchand': 'research and',
            'economcis': 'economics',
            'Journalof': 'Journal of',
            'planing': 'planning',
            'Malaysina': 'Malaysia',
            'ofscientific': 'of scientific',
            'Americanjournal': 'American journal',
            'ouantitative': 'quantitative',
            'quantiative': 'quantitative',
            'quantitative': 'quantitative',
            'quantitative analysis.': 'quantitative analysis',
            ' economy inquiry': 'Economic inquiry',
            'internatioal':'international',
            'indican': 'indian',
            'bankeconomic':'bank economic',
            'basedmanagement': 'based management',
            'macroeconomis': 'macroeconomics',
            'medecine': 'medicine',
            'jounral':'journal',
            'Wp': 'Working paper'
            }

    return reps


def get_journal_reps_contains() -> dict:
    '''
    Returns complete replacements for journal names that contain any of the
    dictionary keys values.
    '''
    
    reps = {'Unpublished': 'Working paper',
            'Mimeo': 'Working paper',
            'Manuscript': 'Working paper',
            'Working paper': 'Working paper',
            'wp ': 'Working paper',
            ' wp': 'Working paper',
            ' wp ': 'Working paper',
            ' dp': 'Working paper',
            ' dp ': 'Working paper',
            'working paper': 'Working paper',
            'Working papers': 'Working paper',
            'thesis': 'Thesis',
            'dissertation': 'Thesis',
            'Phd thesis': 'Thesis',
            'book': 'Book',
            'Book chapter': 'Book',
            'industrielle': 'Relations Industrielles/Industrial Relations',
            'Brooking papers': 'Brookings papers on economic activity',
            'annual conference':'Conference paper',
            'International conference':'Conference paper',
            'association meetings':'Conference paper',
            "Mpra":"Working paper",
            "press":"Book",
            "Press":"Book",
            "discussion paper":"Working paper"}

    return reps

