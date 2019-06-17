%--------------------------------------------------------------------------
% PMA_EnumerateAlg_v11BFS.m
% Breadth-first search implementation
% This new method should be considered under development
% At each level, you can optionally perform for port-type and/or full 
% isomorphism checking (the primary motivation for using BFS)
% Port-type checking is enabled by default as it is faster, while the 
% full checks are disabled as they are generally quite slow
% No mex version is included as it was currently found to be slower
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function SavedGraphs = PMA_EnumerateAlg_v11BFS(cVf,Vf,iInitRep,counts,phi,Ln,A,B,M,Nmax,Mflag,Bflag,dispflag)

% determine some problem properties
Np = sum(Vf); % number of ports
Ne = Np/2; % number of edges (iterations)
Nc = uint16(numel(Vf)); % number of components

% initialize storage elements
Vstorage = zeros(Nmax,Nc,'uint8'); % remaining ports for each vertex
Estorage = zeros(Nmax,Np,'uint8'); % pairwise edges
Astorage = zeros(Nc,Nc,Nmax,'uint8'); % potential adjacency matrix
Tstorage = zeros(Nmax,Ne,'uint16'); % linear index in adjacency matrix
Rstorage = zeros(Nmax,1,'logical');

% for codegen
coder.varsize('Queue',[1,inf],[0,1])
coder.varsize('xInd',[1,inf],[0,1])
Ne = int64(Ne);

% initialize first node
Vstorage(1,:) = Vf;
Astorage(:,:,1) = A;
Queue = 1; % one entry in initial queue
indLast = 1;
xInd = [];
NmaxQueue = Nmax;

% each iteration adds one edge
for iter = 1:Ne

    % reset index for the number of graphs in this loop
    ind = 0;

    % go through the current queue and add one edge
    for node = 1:length(Queue)% must be row vector
        
        % extract current node inputs from storage
        V = Vstorage(node,:);
        E = Estorage(node,:);
        A = Astorage(:,:,node);
        T = Tstorage(node,:);

        % START ENHANCEMENT: touched vertex promotion
        istouched = logical(Vf-V); % vertices that have been touched
        Itouched = find(istouched); % indices of all touched vertices
        Ifull = find(~istouched); % indices of all full vertices
        Isort = [Itouched,Ifull]; % maintain original ordering
        % [~,Ia] = sort(V(Itouched),'ascend'); % alternative sort than maintain
        % [~,Ia] = sort(V(Itouched),'descend'); % alternative sort than maintain
        % Isort = [Itouched(Ia),Ifull];
        Vsort = V(Isort); % sort the vertices
        iL = find(Vsort,1); % find nonzero entries (ports remaining)
        iL = Isort(iL); % obtain original index
        % END ENHANCEMENT: touched vertex promotion

        % remove a port
        L = cVf(iL)-V(iL); % left port 
        V(iL) = V(iL)-1; % remove left port

        % START ENHANCEMENT: replicate ordering
        Vordering = uint8(circshift(V,[0,1]) ~= Vf); % check if left neighbor has been connected to something
        Vordering(iInitRep) = 1; % initial replicates are always 1
        % END ENHANCEMENT: replicate ordering

        % potential remaining ports
        Vallow = V.*Vordering.*A(iL,:);

        % find remaining nonzero entries
        I = find(Vallow);  

        % loop through all nonzero entries
        for iRidx = 1:length(I)
            
            % get right edge
            iR = I(iRidx);
            
            % increment 
            ind = ind + 1;

            % update elements by adding one edge
            [V2,E2,A2,T2,R2] = TreeEnumerateCreatev11BFSInner(V,E,A,T,false,iR,cVf,iter,L,Nc,phi,Ne,Mflag,Vf,Bflag,iL,counts,B,M);

            % save to storage
            if ~R2
                indshift = ind + indLast;
                if indshift > NmaxQueue
                    % error(['need larger Nmax: ',num2str(Vf)])
                    % maybe add more?
                    disp('adding more storage')
                    
                    
                    Vstorage = [Vstorage;zeros(Nmax,Nc,'uint8')]; 
                    Estorage = [Estorage;zeros(Nmax,Np,'uint8')];
                    Astorage = cat(3, Astorage, zeros(Nc,Nc,Nmax,'uint8'));
                    Tstorage = [Tstorage;zeros(Nmax,Ne,'uint16')];
                    Rstorage = [Rstorage;zeros(Nmax,1,'logical')];
                    NmaxQueue = size(Vstorage,1);
                end
                
                Vstorage(indshift,:) = V2;
                Estorage(indshift,:) = E2;
                Astorage(:,:,indshift) = A2;
                Tstorage(indshift,:) = T2;
            else
                Rstorage(ind,1) = R2;
            end

        end % for iR = I
            
    end % end for
    
    %----------------------------------------------------------------------
    % create the indices for the next queue
    %----------------------------------------------------------------------
    % initialize next queue indices
    Queue = 1:ind;
    
    % remove rows marked for deletion
    if ~isempty(Queue)
        Queue(Rstorage) = [];
    end
    
    % shift queue indices based on final row of the previous iteration
    Queue = Queue + indLast;
    
    % update coutner for the number of enteries in current storage elements
    indMax = indLast + ind;
    
    % total number of entries in the queue
    NQueue = length(Queue);
    
    % print
    if dispflag > 2 % very verbose
        fprintf('---\n')    
        fprintf('Iteration: %2i\n',iter)
        fprintf('       Current Queue Length: %8d\n',int64(length(Queue)))
    end
    %----------------------------------------------------------------------
    
    %----------------------------------------------------------------------
    % simple port-type isomorphism check
    %----------------------------------------------------------------------
    Pflag = 1; % NEED: bring outside this function
    if Pflag
        % sort the elements in each row
        Tsort = sort(Tstorage(Queue,:),2,'ascend'); % ascending is a bit faster here

        % obtain the unique connected component adjacency matrices
        [~,IA] = unique(Tsort,'rows');

        % assign current queue to the next queue
        Queue = Queue(IA);
        
        % print
        if dispflag > 2 % very verbose
            fprintf('Removed Graphs (Simple ISO): %8d\n',NQueue-int64(length(Queue)))
        end
    end
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    % full isomorphism check
    %----------------------------------------------------------------------
    Iflag = 0; % NEED: bring outside this function
    if Iflag
        % extract using current queue
        Tsort = sort(Tstorage(Queue,:),2,'ascend'); 
        Vsort = Vstorage(Queue,:);
        
        % determine new queue with only unique graphs
        Queue = PMA_IsoBFS(Queue,Tsort,Ln,Nc,iter,Vsort,dispflag);
    end
    %----------------------------------------------------------------------

    % determine the number of rows for the next queue
    indLast = length(Queue);
    
    % shift up rows for the next queue
    xInd = 1:indLast;
    Vstorage(xInd,:) = Vstorage(Queue,:);
    Estorage(xInd,:) = Estorage(Queue,:);
    Astorage(:,:,xInd) = Astorage(:,:,Queue);
    Tstorage(xInd,:) = Tstorage(Queue,:);
    
    % clean up storage elements
    Rstorage(1:indMax,1) = false;
    % Vstorage(indLast+1:indMax,:) = 0; % not strictly needed
    % Estorage(indLast+1:indMax,:) = 0; % not strictly needed
    % Astorage(:,:,indLast+1:indMax) = 0; % not strictly needed
    % Tstorage(indLast+1:indMax,:) = 0; % not strictly needed

end

% extract results from the final queue
SavedGraphs = Estorage(xInd,:);

end % function PMA_EnumerateAlg_v11BFS
function [V2,E2,A2,T2,R2] = TreeEnumerateCreatev11BFSInner(V2,E2,A2,T2,R2,iR,cVf,iter,L,Nc,phi,Ne,Mflag,Vf,Bflag,iL,counts,B,M)

    % remove another port creating an edge
    R = cVf(iR)-V2(iR); % right port

    % combine left, right ports for an edge
    if R > L % left should be larger
        E2(2*iter-1) = R;
        E2(2*iter) = L;
    else
        E2(2*iter-1) = L;
        E2(2*iter) = R;
    end

    % convert multiple subscripts to linear index
    T2(iter) = Nc*phi(L) - Nc + phi(R); % similar to sub2ind

    V2(iR) = V2(iR)-1; % remove port (local copy)            

    % START ENHANCEMENT: saturated subgraphs
    if iter < Ne
    if Mflag
        iNonSat = find(V2); % find the nonsaturated components 
        if isequal(V2(iNonSat),Vf(iNonSat)) % check for saturated subgraph
            nUncon = sum(M(iNonSat));
            if (nUncon == 0) % define a one set of edges and stop
                % NEED: implement this for v11BFS, currently just continues
%                 for j = 1:sum(V2) % add remaining edges in default order
%                     k = find(V2,1); % find first nonzero entry
%                     LR = cVf(k)-V2(k);
%                     V2(k) = V2(k)-1; % remove port
% 
%                     %%%% needs to change
%                     E2 = [E2,LR]; % add port
%                 end
% %                         [SavedGraphs,id] = TreeSaveGraphs(E2,SavedGraphs,id,dispflag);
%                 continue
                return
            elseif (nUncon == sum(M))
                % continue iterating
            else
                R2 = true; % this graph is infeasible
                return % stop
            end     
        end
    end
    end
    % END ENHANCEMENT: saturated subgraphs

    % START ENHANCEMENT: multi-edges
    if any(counts(iL)) || any(counts(iR)) % if either component needs unique connections
        if (iR ~= iL) % don't do for self loops
            A2(iR,iL) = uint8(0); % limit this connection
            A2(iL,iR) = uint8(0); % limit this connection
        end
    end
    % END ENHANCEMENT: multi-edges

    % START ENHANCEMENT: line-connectivity constraints
    if Bflag
        A2(:,iR) = A2(:,iR).*B(:,iR,iL); % potentially limit connections 
        A2(:,iL) = A2(:,iL).*B(:,iL,iR); % potentially limit connections 
        A2([iR,iL],:) = A2(:,[iR,iL])'; % make symmetric
    end
    % END ENHANCEMENT: line-connectivity constraints
end