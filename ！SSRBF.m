%%%%This is the code for SSRBF produced by Dr Qunming Wang; Email: wqm11111@126.com
%%%%Copyright belong to Qunming Wang
%%%%When using the code, please cite the fowllowing papers
%%%%Q. Wang, L. Wang, Z. Li, X. Tong, P. M. Atkinson. Spatial¨CSpectral Radial Basis Function-Based Interpolation for Landsat ETM+ SLC-Off Image Gap Filling, 2020.

load SLCoff SLCoff
load known known

w=17;
s=20;
sigma1=50;
sigma2=0.1;

[gapfilled]=SSRBF_function(SLCoff,known,w,s,sigma1,sigma2);

