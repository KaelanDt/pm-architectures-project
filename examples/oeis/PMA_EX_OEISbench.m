%--------------------------------------------------------------------------
% PMA_EX_OEISbench.m
% Benchmark code using the OEIS sequences
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

testnum = 3;
opts = [];

% create the test scenario
switch testnum
    %----------------------------------------------------------------------
    case 1 % single function, multiple n values
    F = strings(1,0); N = cell(1,0);
    F(end+1) = "PMA_EX_A053419";
    N{end+1} = 1:7;
    opts.algorithm = 'tree_v11BFS';
    %----------------------------------------------------------------------
    case 2 % several functions, single n values
    F(1) = "PMA_EX_A000014";
    F(2) = "PMA_EX_A000014";
    N{1} = 3;
    N{2} = 14;
    %----------------------------------------------------------------------
    case 3 % primary test
    F = strings(1,0); N = cell(1,0);
    F(end+1) = "PMA_EX_A000014";
    N{end+1} = 17:20;
    F(end+1) = "PMA_EX_A000029";
    N{end+1} = 16:20;
    F(end+1) = "PMA_EX_A000041";
    N{end+1} = 20:32;
    F(end+1) = "PMA_EX_A000055";
    N{end+1} = 14:17;
    F(end+1) = "PMA_EX_A000081";
    N{end+1} = 12:15;
    F(end+1) = "PMA_EX_A000088";
    N{end+1} = 5:7;
    F(end+1) = "PMA_EX_A000110";
    N{end+1} = 8:11;
    F(end+1) = "PMA_EX_A000142";
    N{end+1} = 7:9;
    F(end+1) = "PMA_EX_A000262";
    N{end+1} = 7:9;
    F(end+1) = "PMA_EX_A000272";
    N{end+1} = 7:9;
    F(end+1) = "PMA_EX_A000598";
    N{end+1} = 11:14;
    F(end+1) = "PMA_EX_A000664";
    N{end+1} = 10:12;
    F(end+1) = "PMA_EX_A001147";
    N{end+1} = 14:2:16;
    F(end+1) = "PMA_EX_A001187";
    N{end+1} = 5:6;
    F(end+1) = "PMA_EX_A001190";
    N{end+1} = 10:13;
    F(end+1) = "PMA_EX_A001349";
    N{end+1} = 7:8;
    F(end+1) = "PMA_EX_A001710";
    N{end+1} = 9:11;
    F(end+1) = "PMA_EX_A002094";
    N{end+1} = 12:14;
    F(end+1) = "PMA_EX_A002851";
    N{end+1} = 6:8;
    F(end+1) = "PMA_EX_A002905";
    N{end+1} = 10:13;
    F(end+1) = "PMA_EX_A004108";
    N{end+1} = 7:8;
    F(end+1) = "PMA_EX_A005176";
    N{end+1} = 9:11;
    F(end+1) = "PMA_EX_A005177";
    N{end+1} = 9:11;
    F(end+1) = "PMA_EX_A005333";
    N{end+1} = 3:4;
    F(end+1) = "PMA_EX_A005814";
    N{end+1} = 2:3;
    F(end+1) = "PMA_EX_A006820";
    N{end+1} = 10:12;
    F(end+1) = "PMA_EX_A032279";
    N{end+1} = 18:30;
    F(end+1) = "PMA_EX_A053419";
    N{end+1} = 8:11;
    F(end+1) = "PMA_EX_A054921";
    N{end+1} = 4:6;
    F(end+1) = "PMA_EX_A056156";
    N{end+1} = 6:11;
    F(end+1) = "PMA_EX_A060542";
    N{end+1} = 3:4;
    F(end+1) = "PMA_EX_A108246";
    N{end+1} = 7:10;
    F(end+1) = "PMA_EX_A134818";
    N{end+1} = 6:8;
    F(end+1) = "PMA_EX_A191970";
    N{end+1} = 7:11;
    F(end+1) = "PMA_EX_A261919";
    N{end+1} = 6:8;
    F(end+1) = "PMA_EX_A289158";
    N{end+1} = 6:9;
    F(end+1) = "PMA_EX_A306334";
    N{end+1} = 7:9;
    %----------------------------------------------------------------------
end

% n format string
idxFormat = ['%0',num2str(max(1,ceil(log10(max(cellfun(@max, N)))))),'i']; % pad with correct number of zeros

% initialize incorrect counter
fcounter = 0;

% go through each function to test
for idx = 1:length(F)
    for k = 1:length(N{idx})

        % try to run the test
        try
            % run test
            eval(strcat("[n,f,t,o] = ",F(idx),"(",string(N{idx}(k)),",opts);"));
        catch
            % failed
            n = N{idx}(k); f = false; t = nan; o.algorithm = "?"; o.isomethod = "?";
        end

        % construct string
        str = strings(0);
        str(1) = erase(F(idx),"PMA_EX_") ; % sequence
        str(2) = string(n); % n
        str(3) = string(f); % correct?
        str(4) = num2str(t, '%10.4e'); % time
        str(5) = o.algorithm; % method
        str(6) = o.isomethod; % isomethod
        str(7) = string(java.net.InetAddress.getLocalHost.getHostName);
        str(8) = datestr(now,'yyyy/mm/dd');
        str = strjoin(str,' : ');

        % only if an error
        if ~f
            str = strcat(str," <- NOT CORRECT!!!" );
            fcounter = fcounter + 1;
        end

        % print
        disp(str)
    end
end

% print
disp(strcat(string(fcounter)," tests reported incorrect values"))