# -*- coding: utf-8 -*-
'''
Module for computing meta analysis regressions, and summarising
and calculating regression results and diagnostics.
'''
import numpy as np
import pandas as pd
import statsmodels.api as sm


def extract_resids_pearson(results) -> list:
    ''' Calculates pearson residuals. '''
    return results.resid_pearson


def extract_resids_standard(results) -> list:
    ''' Calculates studentized residuals. '''
    influence = results.get_influence()
    return influence.resid_studentized_internal


def extract_resids_student(results) -> list:
    ''' Calculates studentized residuals, using leave one out estimates. '''
    influence = results.get_influence()
    return influence.resid_studentized_external


def extract_dfbeta(results) -> list:
    ''' Calculates regression DFBETAS. '''
    influence = results.get_influence()
    dfbeta = influence.dfbetas
    return dfbeta


def extract_results(results) -> tuple:
    '''
    Extracts the constant and coefficient terms for a linear model of the
    form: f(x) = a x + c.
    '''
    try:
        const = results.params[0]
        coeff = results.params[1]
    except IndexError:
        const = results.params[0]
        coeff = 0
    return const, coeff


def get_confidence_intervals(results: pd.DataFrame,
                             levels: list=[0.05, 0.10]) -> list:
    '''
    Determines confidence intervals for the list of supplied levels,
    rounded to 3 decimal places.
    '''
    intervals = []
    for level in levels:
        interval_values = (results
                           .conf_int(alpha=level)
                           .transpose()[0]
                           .round(3)
                           .values)
        intervals.append(interval_values)
    return intervals


def transform_y(y, weights):
    return y * weights


def transform_x(x, weights):
    if isinstance(x, pd.DataFrame):
        for col in x.columns:
            x[col] *= weights
    else:
        x *= weights

    return x


def clustered_wls(x: np.array, y: np.array, weights: np.array, groups: np.array):
    '''
    Determines regression coefficients using weighted least squares
    with clustering.

    To implement weighted least squares, the x & y variables are transformed
    s.t. y -> y * w & x -> x * w.

    Clustering is ignored when the number of unique groups is less than 5.

    '''

    y = transform_y(y, weights)

    x = transform_x(x, weights)

    model = sm.OLS(y, x)

    if len(np.unique(groups)) >= 5:
        results = model.fit(cov_type='cluster', cov_kwds={'groups':groups}, use_t=True)
    else:
        results = model.fit()
    return results


def ols_model(data: pd.DataFrame):
    '''
    Estimates the coefficients for the following functional form:

    Effect_size_i = a_0.
    '''

    n = len(data)

    y, x = data['Effect size'], np.ones(n)

    weights, groups = np.ones(len(y)), data['Study no.'].values

    return clustered_wls(x, y, weights, groups)


def wls_model(data: pd.DataFrame):
    '''
    Estimates the coefficients for the following functional form:

    Effect_size_i = a_0,

    with weights = 1 / SE_i.
    '''
    n = len(data)

    y, x = data['Effect size'], np.ones(n)

    weights, groups = 1 / data['Standard error'].values, data['Study no.'].values

    return clustered_wls(x, y, weights, groups)


def fatpet_model(data: pd.DataFrame):
    '''
    Estimates the coefficients for the following functional form:
    ES_i = a_0 + a_1 * SE_i,

    with weights = 1 / SE_i.

    This is referred to as the Fat Pet model (FATPET).
    '''
    y, x = data['Effect size'], data['Standard error']

    x = sm.add_constant(x)

    weights, groups = 1 / data['Standard error'].values, data['Study no.'].values

    return clustered_wls(x, y, weights, groups)


def fatpetp_model(data: pd.DataFrame):
    '''
    Estimates the coefficients for the following functional form:
    ES_i = a_0 + a_1 * SE_i ** 2,

    with weights = 1 / SE_i.

    This is referred to as the Fat Pet Peese model (FATPETP).
    '''

    y, x = data['Effect size'], data['Standard error'] ** 2

    x = sm.add_constant(x)
    
    weights, groups = 1 / data['Standard error'].values, data['Study no.'].values

    return clustered_wls(x, y, weights, groups)


def rfe_model(data: pd.DataFrame):

    n = len(data)

    y, x = data['Effect size'], np.ones(n)

    weights = (1 / (data['Standard error'] ** 2 + data['tsq'])) ** 0.5

    groups = data['Study no.'].values

    return clustered_wls(x, y, weights, groups)


def fpp_model(data: pd.DataFrame):
    '''
    Estimates the FPP model, based on the following condition:

    If the 95 CI contains 0: use the Fat PET model.
    If the 95 CI does not contain 0: use the FAT PET model.
    '''

    results_fatpet = fatpet_model(data)

    results_fatpetp = fatpetp_model(data)

    c95 = (results_fatpet.conf_int(alpha=0.05).values[0]).round(3)

    bneg = (c95[0] < 0) & (c95[1] < 0)
    bpos = (c95[0] > 0) & (c95[1] > 0)

    if bneg | bpos:
        results_fppmodel = results_fatpetp
    else:
        results_fppmodel = results_fatpet
    return results_fppmodel


def calc_regressions(data: pd.DataFrame, how: str='wls'):
    ''' Runs the specified regression method and returns the results. '''

    if how == 'wls':
        return wls_model(data)
    elif how == 'ols':
        return ols_model(data)
    elif how == 'fpp':
        results = fpp_model(data)
    elif how == 'fatpet':
        return fatpet_model(data)
    elif how == 'fatpetp':
        return fatpetp_model(data)
    elif how == 'rfe':
        return rfe_model(data)
    return results


def calc_estimates(data: pd.DataFrame, how: str='wls') -> pd.Series:
    '''
    Determines regression coefficents for all study areas contained
    in the supplied data.
    '''

    cols = ['b1', 'b2']

    if len(data) == 1:
        return pd.Series({f'{col}_{how}': data['Effect size'].values[0] if col == 'b1'
                          else np.nan for col in cols})
    elif len(data) == 0:
        return pd.Series({f'{col}_{how}': np.nan for col in cols})
    else:
        results = calc_regressions(data, how=how)

        vals = extract_results(results)

        return pd.Series({f'{cols[i]}_{how}': val for i, val in enumerate(vals)})


def calc_outliers_tstat(data: pd.DataFrame) -> pd.DataFrame:
    '''
    Determines outlier data points based on whether their t-statistic
    exceeds 100 or not. '''
            
    data['Outlier_tstat'] = False
        
    data.loc[data['t-stat'] >= 100, 'Outlier_tstat'] = True

    return data


def calc_outliers(data: pd.DataFrame) -> pd.DataFrame:
    '''
    Determines outlier data points based on studentized residuals
    calculated from a weighted least squares model.

    A data point x_i is classified as an outlier iff residual(x_i) > 2.5.
    '''

    if len(data) <= 1:
        return pd.DataFrame(index=data.index,
                            data={'Student residual': np.nan,
                                  'Outlier': False})

    results = calc_regressions(data, how='wls')
    res = extract_resids_student(results)
    outliers = abs(res) > 2.5

    return pd.DataFrame(index=data.index,
                        data={'Student residual': res,
                              'Outlier': outliers})


def calc_leverage(data: pd.DataFrame) -> pd.DataFrame:
    '''
    Determines leverage data points based on DFBETAS
    calculated from a weighted least squares model.

    A data point x_i is classified as a leverage point iff

    |dfbeta(x_i)| > 2 / sqrt(x_i).

    '''

    if len(data) <= 1:
        return pd.DataFrame(index=data.index,
                            data={'dfbeta': np.nan,
                                  'leverage_point': False})

    results = calc_regressions(data, how='wls')

    dfbeta = extract_dfbeta(results)[:,results.params.shape[0]-1]

    leverage_points = abs(dfbeta) > 2 / np.sqrt(len(data))

    return pd.DataFrame(index=data.index,
                        data={'dfbeta': dfbeta,
                              'Leverage_point': leverage_points})
