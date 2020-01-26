%--------------------------------------------------------------------------
% INSTALL_PMA_project
% This scripts helps you get the PM Architectures Project up and running
%--------------------------------------------------------------------------
% Automatically adds project files to your MATLAB path, downloads the
% required MATLAB File Exchange submissions, checks your Python setup,
% and opens an example.
%--------------------------------------------------------------------------
% Install script based on MFX Submission Install Utilities
% https://github.com/danielrherber/mfx-submission-install-utilities
% https://www.mathworks.com/matlabcentral/fileexchange/62651
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function INSTALL_PMA_project(varargin)

    % initialize
    silentflag = 0; % don't be silent

    % parse inputs
    if ~isempty(varargin)
        if any(strcmpi(varargin,'silent'))
            silentflag = 1; % be silent
        end
    end

	warning('off','MATLAB:dispatcher:nameConflict');

    % add contents to path
    RunSilent('AddSubmissionContents(mfilename)',silentflag)

    % download required web zips
    RunSilent('RequiredWebZips',silentflag)

    % Matlab isomorphism function check
    RunSilent('CheckMatlabIsomorphismFunction',silentflag)

	% Python check
    RunSilent('PythonSetupCheck',silentflag)

    % run mex creation scripts
    RunSilent('RequiredRunFiles',silentflag)

    % add contents to path
    RunSilent('AddSubmissionContents(mfilename)',silentflag)

	% open an example
    if ~silentflag, OpenThisFile('PMAex_md161635_caseStudy1'); end

	% close this file
    RunSilent('CloseThisFile(mfilename)',silentflag)

	warning('on','MATLAB:dispatcher:nameConflict');

end
%--------------------------------------------------------------------------
function RequiredRunFiles %#ok<DEFNU>

    % initialize index
	ind = 0;

    ind = ind + 1;
    files(ind).file = 'PMA_EnumerationAlg_v1_coder';

    ind = ind + 1;
    files(ind).file = 'PMA_EnumerationAlg_v8_coder';

    ind = ind + 1;
    files(ind).file = 'PMA_EnumerationAlg_v10_coder';

    ind = ind + 1;
    files(ind).file = 'PMA_EnumerationAlg_v11DFS_coder';

    ind = ind + 1;
    files(ind).file = 'PMA_EnumerationAlg_v11BFS_coder';

    % run the files
    RunFiles(files)
end

%--------------------------------------------------------------------------
function RequiredWebZips %#ok<DEFNU>
    disp('--- Obtaining required web zips')

    % initialize index
	ind = 0;

	ind = ind + 1;
	zips(ind).url = 'http://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/10922/versions/2/download/zip/matlab_bgl-4.0.1.zip';
	zips(ind).folder = 'MFX 10922';
	zips(ind).test = 'bfs';

	ind = ind + 1;
	zips(ind).url = 'https://github.com/altmany/export_fig/archive/master.zip';
	zips(ind).folder = 'MFX 23629';
	zips(ind).test = 'export_fig';

	ind = ind + 1;
	zips(ind).url = 'http://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/29438/versions/3/download/zip/cycleCountBacktrack.zip';
	zips(ind).folder = 'MFX 29438';
	zips(ind).test = 'cycleCountBacktrack';

	ind = ind + 1;
	zips(ind).url = 'http://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/40397/versions/7/download/zip/mfoldername_v2.zip';
	zips(ind).folder = 'MFX 40397';
	zips(ind).test = 'mfoldername';

	ind = ind + 1;
	zips(ind).url = 'http://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/47246/versions/3/download/zip/tint.zip';
	zips(ind).folder = 'MFX 47246';
	zips(ind).test = 'tint';

	ind = ind + 1;
	zips(ind).url = 'https://github.com/danielrherber/perfect-matchings-of-a-complete-graph/archive/master.zip';
	zips(ind).folder = 'MFX 52301';
	zips(ind).test = 'PM_perfectMatchings';

    % obtain full function path
    full_fun_path = which(mfilename('fullpath'));
    outputdir = fullfile(fileparts(full_fun_path),'include');

	% download and unzip
    DownloadWebZips(zips,outputdir)

	disp(' ')
end
%--------------------------------------------------------------------------
function CheckMatlabIsomorphismFunction %#ok<DEFNU>
    disp('--- Checking Matlab''s isomorphism function')

    % check if isisomorphic is available
    try
        graph;
        isisomorphic(graph(1,1),graph(1,1));
        disp('isisomorphic is available')
        disp('opts.isomethod = ''Matlab'' is available')
    catch
        disp('opts.isomethod = ''Matlab'' is NOT available X')
        disp('need MATLAB 2016b or newer')
    end
    disp(' ')
end
%--------------------------------------------------------------------------
function PythonSetupCheck %#ok<DEFNU>
	disp('--- Checking Python setup')

    CheckFlag = 0;

	% need python
	[version, ~, ~] = pyversion;
    if isempty(version)
	    disp('python is NOT available X')
    else
        CheckFlag = CheckFlag + 1;
	    disp('python is available')
    end

	% need numpy
    try
        py.numpy.matrixlib.defmatrix.matrix([]);
        CheckFlag = CheckFlag + 1;
	    disp('numpy  is available')
    catch
	    disp('numpy  is NOT available X')
    end

	% need python_igraph
    igraphFlag = false;
    try
        py.igraph.Graph;
        if CheckFlag == 2
            igraphFlag = true;
        end
        disp('igraph is available')
    catch
        disp('igraph is NOT available X')
    end

    % need python_networkx
    networkxFlag = false;
    try
        py.networkx.Graph();
        if CheckFlag == 2
            networkxFlag = true;
        end
        disp('networkx is available')
    catch
        disp('networkx is NOT available X')
    end

    % if all required python packages are available
    if igraphFlag || networkxFlag
        disp('opts.isomethod = ''python'' is available')
    else
        disp('opts.isomethod = ''python'' is NOT available X')
        disp('please see https://github.com/danielrherber/pm-architectures-project/blob/master/optional/PythonIsoSetup.md')
    end

	disp(' ')
end
%--------------------------------------------------------------------------
function AddSubmissionContents(name) %#ok<DEFNU>
    disp('--- Adding submission contents to path')
    disp(' ')

    % current file
    fullfuncdir = which(name);

    % current folder
    submissiondir = fullfile(fileparts(fullfuncdir));

    % add folders and subfolders to path
    addpath(genpath(submissiondir))
end
%--------------------------------------------------------------------------
function CloseThisFile(name) %#ok<DEFNU>
    disp(['--- Closing ', name])
    disp(' ')

    % get editor information
    h = matlab.desktop.editor.getAll;

    % go through all open files in the editor
    for k = 1:numel(h)
        % check if this is the file
        if ~isempty(strfind(h(k).Filename,name))
            % close this file
            h(k).close
        end
    end
end
%--------------------------------------------------------------------------
function OpenThisFile(name)
    disp(['--- Opening ', name])

    try
        % open the file
        open(name);
    catch % error
        disp(['Could not open ', name])
    end

    disp(' ')
end
%--------------------------------------------------------------------------
function DownloadWebZips(zips,outputdir)

    % store the current directory
    olddir = pwd;

    % create a folder for outputdir
    if ~exist(outputdir, 'dir')
        mkdir(outputdir); % create the folder
    else
        addpath(genpath(outputdir)); % add folders and subfolders to path
    end

    % change to the output directory
    cd(outputdir)

    % go through each zip
    for k = 1:length(zips)

        % get data
        url = zips(k).url;
        folder = zips(k).folder;
        test = zips(k).test;

        % first check if the test file is in the path
        if exist(test,'file') == 0

            try
                % download zip file
                zipname = websave(folder,url);

                % save location
                outputdirname = fullfile(outputdir,folder);

                % create a folder utilizing name as the foldername name
                if ~exist(outputdirname, 'dir')
                    mkdir(outputdirname);
                end

                % unzip the zip
                unzip(zipname,outputdirname);

                % delete the zip file
                delete([folder,'.zip'])

                % output to the command window
                disp(['Downloaded and unzipped ',folder])

            catch % failed to download
                % output to the command window
                disp(['Failed to download ',folder])

                % remove the html file
                delete([folder,'.html'])

            end

        else
            % output to the command window
            disp(['Already available ',folder])
        end
    end

    % change back to the original directory
    cd(olddir)
end
%--------------------------------------------------------------------------
function RunSilent(str,silentflag)
    if silentflag
        O = evalc(str); %#ok<NASGU>
    else
        eval(str);
    end
end
%--------------------------------------------------------------------------
function RunFiles(files)

    % go through each file and run
    for k = 1:length(files)
        disp(['--- Running ', files(k).file])

        try
            % run the file
            run(files(k).file);
        catch % error
            disp(['Could not run ', files(k).file])
        end

        disp(' ')
    end

end