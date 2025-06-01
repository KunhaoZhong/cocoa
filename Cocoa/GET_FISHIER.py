import numpy as np
import sys, os
from copy import deepcopy

from cobaya.yaml import yaml_load_file
from cobaya.run import run


def get_full_cov(cov_file, output_dims):
    print("Getting covariance...")
    full_cov = np.loadtxt(cov_file)
    cov = np.zeros((output_dims, output_dims))
    cov_scenario = full_cov.shape[1]
    
    for line in full_cov:
        i = int(line[0])
        j = int(line[1])

        if(cov_scenario==3):
            cov_ij = line[2]
        elif(cov_scenario==10):
            cov_g_block  = line[8]
            cov_ng_block = line[9]
            cov_ij = cov_g_block + cov_ng_block

        cov[i,j] = cov_ij
        cov[j,i] = cov_ij

    return cov


def get_model_vector(info):
    updated_info, _ = run(info)
    model_vec = np.loadtxt(info['likelihood']['des_y3.des_3x2pt']['print_datavector_file'])
    return model_vec[:,1][mask]


if __name__ == "__main__":
    PROJECT_DIR = './projects/des_y3/'
    
    info_from_yaml = yaml_load_file(PROJECT_DIR+"EXAMPLE_GG_EVALUATE2.yaml")
    info_fishier = info_from_yaml

    info_fishier['likelihood']['des_y3.des_3x2pt']['print_datavector']=True
    info_fishier['likelihood']['des_y3.des_3x2pt']['print_datavector_file']=PROJECT_DIR+"chains/fishier_tmp_fid.modelvector"
    info_fishier['force'] = True

    # updated_info, sampler = run(info_fishier) # run 
    
    mask = np.loadtxt(PROJECT_DIR+'data/3x2pt_baseline.mask')[:,1].astype(bool)
    dv_fid = np.loadtxt(PROJECT_DIR+'chains/fishier_tmp_fid.modelvector')
    len_dv_full = len(dv_fid)
    dv_fid = dv_fid[:,1][mask]
    real_dv = np.loadtxt(PROJECT_DIR+'data/des_y3_unblinded_final.txt')
    real_dv = real_dv[:,1][mask]

    cov_mat = get_full_cov(PROJECT_DIR+'data/des_y3_cov_unblinded_final.txt', len_dv_full)
    cov_mat = cov_mat[np.ix_(mask, mask)]
    cov_mat_inv = np.linalg.inv(cov_mat)
    cov_mat_inv = cov_mat_inv

    ## ============== Fisher Calculation Start ============== ##
    
    param_names = list(info_fishier['sampler']['evaluate']['override'].keys())
    derivatives = []

    param_names = param_names[0:6] # only do cosmology
    
    for p in param_names:
        print(f"Computing derivative for {p}")
        delta = 0.0001 * info_fishier['sampler']['evaluate']['override'][p] # adjust as needed
        fid_vlua = info_from_yaml['sampler']['evaluate']['override'][p]
        # +delta
        info_p = deepcopy(info_fishier)
        info_p['sampler']['evaluate']['override'][p] = fid_vlua+delta
        info_p['likelihood']['des_y3.des_3x2pt']['print_datavector_file'] = f"./projects/des_y3/chains/tmp_plus_{p}.dat"
        d_plus = get_model_vector(info_p)
    
        # -delta
        info_m = deepcopy(info_fishier)
        info_m['sampler']['evaluate']['override'][p] = fid_vlua-delta
        info_m['likelihood']['des_y3.des_3x2pt']['print_datavector_file'] = f"./projects/des_y3/chains/tmp_minus_{p}.dat"
        d_minus = get_model_vector(info_m)
    
        deriv = (d_plus - d_minus) / (2 * delta)
        derivatives.append(deriv)
    
    # Convert to 2D numpy array
    derivatives = np.array(derivatives)  # shape (n_params, n_data)

    fisher = derivatives @ cov_mat_inv @ derivatives.T
    inv_fisher = np.linalg.inv(fisher)

    fisher_filename = PROJECT_DIR+'inv_fisher.covmat'
    
    header = ' '.join(param_names)
    
    np.savetxt(fisher_filename, inv_fisher, header=header, fmt='%.6e')