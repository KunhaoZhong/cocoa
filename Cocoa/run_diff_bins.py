import numpy as np
import os, sys, time
from io import StringIO
from cobaya.yaml import yaml_load_file
from cobaya.run import run
from cobaya.post import post
from getdist.mcsamples import MCSamplesFromCobaya


info_lcdm = yaml_load_file("./projects/lsst_y1/EXAMPLE_KZ_MOD.yaml")

kbins = 6
zbins = 6

diff = 0.001

for i in range(zbins - 1):
    bin_name = "zbin" + str(i)
    bin_value = "zvalue" + str(i)
    info_lcdm['likelihood']['lsst_y1.lsst_cosmic_shear']['print_datavector_file'] = "./projects/lsst_y1/chains/tmp_z_pside_" + str(diff)+'_' + bin_name + ".modelvector"
    info_lcdm["params"][bin_value]["value"] = 1.+ diff/2
    updated_info, evaluate = run(info_lcdm, force=True)

for i in range(zbins - 1):
    bin_name = "zbin" + str(i)
    bin_value = "zvalue" + str(i)
    info_lcdm['likelihood']['lsst_y1.lsst_cosmic_shear']['print_datavector_file'] = "./projects/lsst_y1/chains/tmp_z_mside_"+ str(diff)+'_' + bin_name + ".modelvector"
    info_lcdm["params"][bin_value]["value"] = 1.- diff/2
    updated_info, evaluate = run(info_lcdm, force=True)

for i in range(kbins - 1):
    bin_name = "kbin" + str(i)
    bin_value = "kvalue" + str(i)
    info_lcdm['likelihood']['lsst_y1.lsst_cosmic_shear']['print_datavector_file'] = "./projects/lsst_y1/chains/tmp_k_pside_"+ str(diff)+'_' + bin_name + ".modelvector"
    info_lcdm["params"][bin_value]["value"] = 1.+ diff/2
    updated_info, evaluate = run(info_lcdm, force=True)

for i in range(kbins - 1):
    bin_name = "kbin" + str(i)
    bin_value = "kvalue" + str(i)
    info_lcdm['likelihood']['lsst_y1.lsst_cosmic_shear']['print_datavector_file'] = "./projects/lsst_y1/chains/tmp_k_mside_"+ str(diff)+'_' + bin_name + ".modelvector"
    info_lcdm["params"][bin_value]["value"] = 1. - diff/2
    updated_info, evaluate = run(info_lcdm, force=True)