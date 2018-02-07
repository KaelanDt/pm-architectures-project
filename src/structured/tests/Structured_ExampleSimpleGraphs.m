%--------------------------------------------------------------------------
% Structured_ExampleSimpleGraphs.m
% Create or loading graph examples
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Additional Contributor: Shangtingli, Undergraduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [C,R,P,S,FinalGraphs] = Structured_ExampleSimpleGraphs(example,opts)
folder = mfoldername(mfilename('fullpath'),'');

switch example
    % Real Scenario with 1 planetary gear
    case 1
        fullname = [folder 'Bayrak1.mat'];
        try
            Info = load(fullname);
            C = Info.C;
            P = Info.P;
            S = Info.S;
            R = Info.R;
            FinalGraphs = Info.FinalGraphs;
            clearvars Info
        catch
            R.min = [1 0 1 0 1 0 0]'; % replicates min vector
            R.max = [2 1 1 1 1 1 1]';
            C = {'M','E','V','G','P','A','B'};
            P = [1 1 1 1 3 3 4];
            S = [0 0 0 0 1 0 0];
            NSC.counts = 1; % unique edges
            NSC.A = ones(length(P));
            NSC.A(6,6) = 0; % no A-A
            NSC.A(7,7) = 0; % no B-B
            NSC.A(7,6) = 0; % no B-A
            FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);
            save(fullname,'C','R','P','S','FinalGraphs');
        end
    % Real Scenario with 2 planetary gears
    case 2
        fullname = [folder 'Bayrak2.mat'];
        try
            Info = load(fullname);
            C = Info.C;
            P = Info.P;
            S = Info.S;
            R = Info.R;
            FinalGraphs = Info.FinalGraphs;
            clearvars Info
        catch
            R.min = [1 0 1 0 1 0 0]'; % replicates min vector
            R.max = [2 1 1 1 2 1 1]';
            C = {'M','E','V','G','P','A','B'};
            P = [1 1 1 1 3 3 4];
            S = [0 0 0 0 1 0 0];
            NSC.counts = 1; % unique edges
            NSC.A = ones(length(P));
            NSC.A(6,6) = 0; % no A-A
            NSC.A(7,7) = 0; % no B-B
            NSC.A(7,6) = 0; % no B-A
            FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);
            save(fullname,'C','R','P','S','FinalGraphs');
        end
    % Modified Scenario 1 with 1 planetary gears. All ports > 1 components
    % are designated as structured components
    case 3
        fullname = [folder 'BayrakModified1.mat'];
        try
            Info = load(fullname);
            C = Info.C;
            P = Info.P;
            S = Info.S;
            R = Info.R;
            FinalGraphs = Info.FinalGraphs;
            clearvars Info
        catch
            R.min = [1 0 1 0 1 0 0]'; % replicates min vector
            R.max = [2 1 1 1 1 1 1]';
            C = {'M','E','V','G','P','A','B'};
            P = [1 1 1 1 3 3 4];
            S = [0 0 0 0 1 1 1];
            NSC.counts = 1; % unique edges
            NSC.A = ones(length(P));
            NSC.A(6,6) = 0; % no A-A
            NSC.A(7,7) = 0; % no B-B
            NSC.A(7,6) = 0; % no B-A
            FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);
            save(fullname,'C','R','P','S','FinalGraphs');
        end
    % Modified Scenario 2 with 1 planetary gears. All ports > 1 components
    % are designated as structured components. All ports = 1 components are
    % designated the same label.
    case 4
        try
            fullname = [folder 'BayrakModified2.mat'];
            Info = load(fullname);
            C = Info.C;
            P = Info.P;
            S = Info.S;
            FinalGraphs = Info.FinalGraphs;
            clearvars Info
        catch
            R.min = [2 1 0 0]'; % replicates min vector
            R.max = [5 1 1 1]';
            C = {'M','P','A','B'};
            P = [1 3 3 4];
            S = [0 1 1 1]; 
            NSC.counts = 1;  
            FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);
            save(fullname,'C','R','P','S','FinalGraphs');
        end
    % Modified Scenario 1 with 2 planetary gears. All ports > 1 components
    % are designated as structured components
    case 5
        fullname = [folder 'BayrakModified3.mat'];
        try
            Info = load(fullname);
            C = Info.C;
            P = Info.P;
            S = Info.S;
            R = Info.R;
            FinalGraphs = Info.FinalGraphs;
            clearvars Info
        catch
            R.min = [1 0 1 0 1 0 0]'; % replicates min vector
            R.max = [2 1 1 1 2 1 1]';
            C = {'M','E','V','G','P','A','B'};
            P = [1 1 1 1 3 3 4];
            S = [0 0 0 0 1 1 1];
            NSC.counts = 1; % unique edges
            NSC.A = ones(length(P));
            NSC.A(6,6) = 0; % no A-A
            NSC.A(7,7) = 0; % no B-B
            NSC.A(7,6) = 0; % no B-A
            FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);
            save(fullname,'C','R','P','S','FinalGraphs');
        end
    % Modified Scenario 2 with 2 planetary gears. All ports > 1 components
    % are designated as structured components. All ports = 1 components are
    % designated the same label.
    case 6
        try
            fullname = [folder 'BayrakModified4.mat'];
            Info = load(fullname);
            C = Info.C;
            P = Info.P;
            S = Info.S;
            R = Info.R;
            FinalGraphs = Info.FinalGraphs;
            clearvars Info
        catch
            R.min = [2 1 0 0]'; % replicates min vector
            R.max = [5 2 1 1]';
            C = {'M','P','A','B'};
            P = [1 3 3 4];
            S = [0 1 1 1]; 
            NSC.counts = 1;  
            FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);
            save(fullname,'C','R','P','S','FinalGraphs');
        end
    % All components are structured
    case 7
        fullname = [folder 'BayrakModified5.mat'];
        try
            Info = load(fullname);
            C = Info.C;
            P = Info.P;
            S = Info.S;
            R = Info.R;
            FinalGraphs = Info.FinalGraphs;
            clearvars Info
        catch
            R.min = [1 0 1 0 1 0 0]'; % replicates min vector
            R.max = [2 1 1 1 1 1 1]';
            C = {'M','E','V','G','P','A','B'};
            P = [1 1 1 1 3 3 4];
            S = [1 1 1 1 1 1 1];
            NSC.counts = 1; % unique edges
            NSC.A = ones(length(P));
            NSC.A(6,6) = 0; % no A-A
            NSC.A(7,7) = 0; % no B-B
            NSC.A(7,6) = 0; % no B-A
            FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);
            save(fullname,'C','R','P','S','FinalGraphs');
        end
end

end