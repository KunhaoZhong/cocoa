import numpy as np
import sys, os
from copy import deepcopy
from cobaya.yaml import yaml_load_file
from cobaya.run import run
from getdist import MCSamples
from getdist import loadMCSamples


def find_minimum_chi2_from_file(filename, params_to_sample, burn_in=0.0, nmpi=4):
    analysissettings = {'ignore_rows': burn_in}
    gd_params = loadMCSamples(filename,settings=analysissettings).getParams()
    these_chi2 = gd_params.chi2
    min_chi2_idx = np.argmin(these_chi2)

    params_at_min_chi2 = {}

    for attr in params_to_sample:
        tmp = getattr(gd_params, attr) # list of this paramter
        params_at_min_chi2[attr] = tmp[min_chi2_idx]
    return params_at_min_chi2
    

if __name__ == "__main__":
    PROJECT_DIR = './projects/des_y3/'

    chain_name = 'MCMC43_LCDM'
    
    info_base = yaml_load_file(PROJECT_DIR+"chains/dr2_GG_" + chain_name + ".updated.yaml")
    default_output =                   "./projects/des_y3/chains/dr2_GG_" + chain_name

    n_stages = 5

    # taken from 2401.14225
    t_steps = [0.33, 0.25, 0.2, 0.1, 0.005, 0.001]# how you want to decrease temperature
    scale_steps = [1., 0.8, 0.5, 0.2, 0.1, 0.05]# how you want to decrease step size

    _params_to_sample = []

    for this_p in info_base['params']:
        if 'prior' in info_base['params'][this_p]:
            _params_to_sample.append(this_p)

    # start creating new yamls for MAP calculation
    for i in range(0, n_stages):
        info_map = deepcopy(info_base)
        if i == 0:
            last_output = default_output
            burn_in = 0.7
        else:
            last_output = default_output + '_MAP_STAGE_' + str(i+1-1)
            burn_in = 0.0
    
        info_map['output'] = default_output + '_MAP_STAGE_' + str(i+1)
        info_map['force'] = False
        info_map['resume'] = True
        # sampler settings
        info_map['sampler']['mcmc']['max_samples'] = 1500 # subject to change
        info_map['sampler']['mcmc']['temperature'] = t_steps[i]
        info_map['sampler']['mcmc']['proposal_scale'] =  scale_steps[i]

        params_at_min_chi2 = find_minimum_chi2_from_file(last_output, _params_to_sample, burn_in=burn_in)
        for this_p in params_at_min_chi2:
            info_map['params'][this_p]['ref'] = params_at_min_chi2[this_p]

        print('RUNNING MAP STAEGE {}'.format(i+1))
        _, _ = run(info_map) # run 
    
