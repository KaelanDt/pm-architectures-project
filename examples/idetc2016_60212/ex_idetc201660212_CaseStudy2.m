%--------------------------------------------------------------------------
% ex_idetc201660212_CaseStudy2.m
% This example replicates the results from Case Study 2 in the paper below
%--------------------------------------------------------------------------
% http://systemdesign.illinois.edu/publications/Her16b.pdf
% FIGURE 12: All 12 unique graphs for Case Study 2 requiring all components 
% to be connected and a specified number of unique edges.
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% test number
num = 1; 

% problem specification
P = [1 1 2 3 4]; % ports vector
R = [1 2 2 1 1]; % replicates vector
C = {'P','R', 'G', 'B', 'O'}; % label vector

% different modifications to original problem specification
switch num
    case 1 % Case Study 2, #1 constraints
        NSC.M = [0 0 0 0 0];
    case 2 % Case Study 2, #2 constraints
        NSC.M = [1 0 0 0 0];
    case 3 % Case Study 2, #3 constraints
        NSC.M = [1 1 1 1 1];       
        NSC.counts = 1;
    case 4 % Case Study 2, #4 constraints
        P = [1 1 2 2 3 4]'; % ports vector
        R = [1 2 1 1 1 1]'; % replicates vector
        C = {'P','R', 'G', 'G', 'B', 'O'}; % label vector
        NSC.M = [1 1 1 0 1 1];
        NSC.counts = 1;
end

% options
opts.algorithm = 'tree_v1'; %
opts.Nmax = 1e7; % maximum number of graphs to preallocate for
opts.parallel = 0; % 0 to disable parallel computing, otherwise max number of workers
opts.filterflag = 1; % 1 is on, 0 is off
% opts.customfun = @(pp,A,infeasibleFlag) ex_Example2_Extra_Constraints(pp,A,infeasibleFlag);
opts.isomethod = 'matlab'; % option 'Matlab' is available in 2016b or later versions

opts.plots.plotfun = 'bgl'; % 'circle' % 'bgl' % 'bio' % 'matlab'
opts.plots.plotmax = 20; % maximum number of graphs to display/save
opts.plots.name = mfilename; % name of the example
opts.plots.path = mfoldername(mfilename('fullpath'),[opts.plots.name,'_figs']); % path to save figures to
opts.plots.labelnumflag = 0; % add replicate numbers when plotting

% generate graphs
FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);