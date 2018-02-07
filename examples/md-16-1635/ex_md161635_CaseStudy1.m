%--------------------------------------------------------------------------
% ex_md161635_CaseStudy1.m
% This example replicates the results from Case Study 1 in the paper below
%--------------------------------------------------------------------------
% Herber DR, Guo T, Allison JT. Enumeration of Architectures With Perfect
% Matchings. ASME. J. Mech. Des. 2017;139(5):051403. doi:10.1115/1.4036132
% FIGURE 10: All 16 unique graphs with no additional NSCs for Case Study 1.
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% test number
num = 1; 

% use the newer algorithm with enhancements? see tech. report on README
newalgo = 0; % 0:no, 1:yes

% problem specification
P = [1 2 3]; % ports vector 
R = [3 2 1]; % replicates vector
C = {'R','G','B'}; % label vector

% different modifications to original problem specification
switch num
    case 1 % Case Study 1, #1
        NSC = []; % no constraints
    case 2 % Case Study 1, #2 constraints
        NSC.M = [0 0 1];
        % NSC.M = [1 1 1];
        NSC.counts = 1;
end

% options
if newalgo
    opts.algorithm = 'tree_v8'; % new
else
    opts.algorithm = 'tree_v1'; % old
end
opts.Nmax = 1e7; % maximum number of graphs to preallocate for
opts.parallel = 0; % 0 to disable parallel computing, otherwise max number of workers
opts.filterflag = 1; % 1 is on, 0 is off
% opts.customfun = @(pp,A,infeasibleFlag) ex_Example1_Extra_Constraints(pp,A,infeasibleFlag);
opts.plotfun = 'circle'; % 'circle' % 'bgl' % 'bio' % 'matlab'
% opts.plotmax = Inf; % maximum number of graphs to display/save
opts.plotmax = 100;
opts.saveflag = 0; % save graphs to disk
opts.name = mfilename; % name of the example
opts.path = mfoldername(mfilename('fullpath'),[opts.name,'_figs']); % path to save figures to
opts.isomethod = 'Matlab'; % option 'Matlab' is available in 2016b or later versions

% generate graphs
FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);