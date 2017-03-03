function [varargout]=quiverVec(varargin)


%% Parse input

switch nargin
    case 2
        P=varargin{1};
        V=varargin{2};
        vecSize=[];
        colorSpec=[];
        edgeColorOpt='none';
        quiverStyleOpt=1;
    case 3
        P=varargin{1};
        V=varargin{2};
        vecSize=varargin{3};
        colorSpec=[];
        edgeColorOpt='none';
        quiverStyleOpt=1;
    case 4
        P=varargin{1};
        V=varargin{2};
        vecSize=varargin{3};
        colorSpec=varargin{4};        
        edgeColorOpt='none';
        quiverStyleOpt=1;
    case 5
        P=varargin{1};
        V=varargin{2};
        vecSize=varargin{3};
        colorSpec=varargin{4};
        edgeColorOpt=varargin{5};
        quiverStyleOpt=1;
    case 6
        P=varargin{1};
        V=varargin{2};
        vecSize=varargin{3};
        colorSpec=varargin{4};
        edgeColorOpt=varargin{5};
        quiverStyleOpt=varargin{6};
end
   
if isempty(edgeColorOpt)
    edgeColorOpt='none';
end

switch quiverStyleOpt
    case 1 %Depart from origin
        %Keep as is
    case 2 %Arrive at origin
        P=P-V;
    case 3 %Pass through origin
        P=P-(V/2);
    case 4 %Two-sided
        P=[P;P];
        V=[V;-V];
        if ~ischar(colorSpec) && size(colorSpec,1)>1
            colorSpec=[colorSpec;colorSpec];
        end
end

if numel(vecSize)==1
    vecSize=vecSize*ones(1,2);
end

if ischar(colorSpec)    
    [F,P,~]=quiver3Dpatch(P(:,1),P(:,2),P(:,3),V(:,1),V(:,2),V(:,3),[],vecSize);    
    C=colorSpec;
else
    if size(colorSpec,1)==1 %If only 1 color is provided
        colorSpec=colorSpec(ones(size(P,1),1),:); %copy for all vectors
    end
        
    [F,P,C]=quiver3Dpatch(P(:,1),P(:,2),P(:,3),V(:,1),V(:,2),V(:,3),colorSpec,vecSize);    
end

varargout{1}=gpatch(F,P,C,edgeColorOpt,1);