%--------------------------------------------------------------------------
% Normal Computing
% RLC circuit netlists generation code
%--------------------------------------------------------------------------
clear; clc; close all; 

% problem specifications
P = [2 2 2 3]; % ports vector: number of ports per component
R.min = [1 1 1 1]; R.max = [2 2 1 2]; % replicates vector: bounds on number
% of components of each type
C = {'R','L','C', 'N'}; % label vector, RLC circuits with nodes with 
% 3 and 4 ports

% number of desired cases
num = 2;

% different modifications to original problem specification
switch num
    %----------------------------------------------------------------------
    case 2 % one 3-port structured components (44 graphs)
    NSC.S = [1,1,1,0]; % structured components
    %NSC.connections = 1
    NSC.loops = 0; % no loops allowed
    NSC.simple = 1; % all connections must be unique
    %----------------------------------------------------------------------
    %NSC.S = [0,1,1]; % structured components
    %----------------------------------------------------------------------
    %case 4 % only some mandatory components, simple graph (16 graphs)
    %R.min = [0 0 1]; R.max = [3 2 1]; % replicates vector
    %NSC.loops = 0; % no loops allowed
    %NSC.simple = 1; % all connections must be unique
    %NSC.S = [0,0,1]; % structured components
    %----------------------------------------------------------------------
end

% structured-specific options
opts.structured.isotree = 'AIO'; % AIO (all-in-one) or LOE (level-order)
opts.structured.ordering = 'none'; % RA

% general options
opts.plots.plotmax = 10; % number of example graphs to be plotted
opts.plots.labelnumflag = false;
opts.isomethod = 'py-igraph'; % labeled graph isomorphism checking method
opts.parallel = false; % no parallel computing

% generate graphs
final_graphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);

% create .cir files from graph list 
for i = 1:1
    disp(i)
    f = fopen('circuits_data/fname.cir', 'w')
    % Template circuit for bandpass filter problem.
    fprintf(f, '%0s %2.1d %4.1d %6s\n', 'Vin',0 , 1,'Symbolic')
    fprintf(f, '%0s %2.1d %4.1d %6s\n', 'Rin',0 , 1,'')

    fclose(f)
    %final_graphs(i)
end


fname = 'circuits_data/fname.cir' %fname to be given to SCAM
scam %launch solver, will create variables for each solved voltage and current.


