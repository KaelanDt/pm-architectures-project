%--------------------------------------------------------------------------
% PMA_EX_A032279
% A032279, number of bracelets (turnover necklaces) of n beads of 2 colors,
% 5 of them black
% 1, 1, 3, 5, 10, 16, 26, 38, 57, 79, 111, 147, 196, 252, 324, 406, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 15; % number of nodes (currently completed for n = 30)
L = {'W','B'}; % labels
R.min = [n-5 5]; R.max = [n-5 5]; % replicate vector
P.min = [2 2]; P.max = [2 2]; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.colorlib = @CustomColorLib;
opts.algorithm = 'tree_v11DFS_mex';
opts.algorithms.Nmax = 1e7;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = 12;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A032279
N = [1,1,3,5,10,16,26,38,57,79,111,147,196,252,324,406,507,621,759,913,...
    1096,1298,1534,1794,2093,2421,2793,3199,3656,4152,4706,5304,5967,...
    6681,7467,8311,9234,10222,11298,12446,13691,15015,16445];
n2 = N(n-4);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))

function c = CustomColorLib(L)
c = zeros(length(L),3); % initialize
for k = 1:length(L) % go through each label and assign a color
    switch upper(L{k})
        case 'W'
            ct = [0.9 0.9 0.9];
        case 'B'
            ct = [0.4 0.4 0.4];
    end
    c(k,:) = ct; % assign
end
end