# -*- coding: utf-8 -*-
"""
Created on Thu Feb 23 22:55:49 2023

@author: xinlo
"""
import h5py
filename = "../../../../RWDI/Wind Tunnel Data/tilt_n5deg.hdf5"

with h5py.File(filename, "r") as f:
    # Print all root level object names (aka keys) 
    # these can be group or dataset names 
    print("Keys: %s" % f.keys())
    # get first object name/key; may or may NOT be a group
    a_group_key = list(f.keys())[0]

    # get the object type for a_group_key: usually group or dataset
    print(type(f[a_group_key])) 

    # If a_group_key is a group name, 
    # this gets the object names in the group and returns as a list
    data = list(f[a_group_key])

    # # If a_group_key is a dataset name, 
    # # this gets the dataset values and returns as a list
    # data = list(f[a_group_key])
    # preferred methods to get dataset values:
    ds_obj = f[a_group_key]['Row1']      # returns as a h5py dataset object
    ds_arr = f[a_group_key]['Row1'][()]  # returns as a numpy array
    
    