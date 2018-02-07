%--------------------------------------------------------------------------
% ex_md161635_Suspension.m
% This example replicates the results from Case Study 3 in the paper below
%--------------------------------------------------------------------------
% Herber DR, Guo T, Allison JT. Enumeration of Architectures With Perfect
% Matchings. ASME. J. Mech. Des. 2017;139(5):051403. doi:10.1115/1.4036132
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% problem specification
P = [1 1 1 2 2 2 3 4]'; % ports vector 
R = [1 1 2 2 2 1 2 2]'; % replicate vector 
C = {'s','u','m', 'k', 'b', 'f', 'p', 'p'}; % label vector 

% constraints
NSC.M = [1 1 0 0 0 0 0 0];
NSC.counts = 1;
% NSC.self = 1; % allow self-loops
% provide potential adjacency matrix
A = ones(length(P));
A(2,1) = 0;
A(3,1) = 0;
A(3,2) = 0;
A(4,4) = 0;
A(5,5) = 0;
A(7,7) = 0;
A(8,7) = 0;
A(8,8) = 0;
A = round((A+A')/3);
NSC.A = A;

% options
opts.algorithm = 'tree_v1';
opts.Nmax = 2e8; % maximum number of graphs to preallocate for
opts.parallel = 12; % 1 to enable parallel computing, 0 to disable it
opts.filterflag = 1; % 1 is on, 0 is off
opts.customfun = @(pp,A,infeasibleFlag) ex_md161635_Suspension_Extra_Constraints(pp,A,infeasibleFlag);
opts.plotfun = 'bgl'; % 'circle' % 'bgl' % 'bio'
opts.plotmax = 0; % maximum number of graphs to display/save
opts.name = mfilename; % name of the example
opts.path = mfoldername(mfilename('fullpath'),[opts.name,'_figs']); % path to save figures to
opts.isomethod = 'Python'; % option 'Matlab' is available in 2016b or later versions

% generate graphs
FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);