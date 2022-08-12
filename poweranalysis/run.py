# -*- coding: utf-8 -*-
from .analysis import (get_all_data,
                       estimate_all,
                       filter_for_reporting)


from .summaries import (data_sharing_summaries,
                        journal_data_subsets)

from .paths import get_outputs_dir


def run_local(method: str, suffix: str=''):

    print(f'Running with method={method}')

    all_data = get_all_data()

    all_data, reg_results = estimate_all(all_data, method, suffix=suffix)

    all_data = filter_for_reporting(all_data)

    output_dir = get_outputs_dir()

    if method == 'wls':
        data_sharing_summaries(output_dir, method, suffix, all_data, reg_results)

    journal_data_subsets(output_dir, method, suffix, all_data)
