close all; clear; clc;
filename = '../../../RWDI/Wind Tunnel Data/tilt_n5deg.hdf5';
h5disp(filename)
info = h5info(filename)
level2 = info.Groups(2)
data = h5read(filename,'/WindDir_30deg/Row1');
dtNorm = h5read(filename,'/WindDir_30deg/dtNorm');