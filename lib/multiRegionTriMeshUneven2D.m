function [F,V,regionInd]=multiRegionTriMeshUneven2D(regionSpec,BoundaryPointSpacings,MeshPointSpacings,plotOn)

% function [F,V,regionInd]=multiRegionTriMesh2D(regionSpec,pointSpacing,plotOn)
% ------------------------------------------------------------------------
% This function creates a 2D triangulation for each of the regions
% specified in the variable regionSpec. The mesh aims to obtain a point
% spacing as defined by the input pointSpacing. The triangulation is based
% on a 2D constrained Delaunary triangulation. The constraints are formed
% by the boundary curves inside the regionSpec cell. Large areas, with
% respect to the pointSpacing, will contain a near homogeneous and
% aproximately equilateral triangulations. Other regions (e.g. at
% boundaries and thin/complex shapes) will contain other triangulation
% types. 
% The function output contains the triangular faces in F, the vertices in V
% and the per triangle region indices in regionInd. By setting plotOn to 0
% or 1 plotting can be switched on or off. 
%
% More on the specification of regions:
% Regions are defined as cell entries in the input variable regionSpec for
% instnace region 1 is found in regionSpec{1}. Each region entry is itself
% also a cell array containing all the boundary curves, e.g. for a two
% curve region 1 we would have something like regionSpec{1}={V1,V2} where
% V1 and V2 are the boundary curves. Multiple curves may be given here. The
% first curve should form the outer boundary of the entire region, the
% curves that follow should define holes inside this boundary and the
% space inside them is therefore not meshed. The boundary vertices for
% regions that share boundaries are merged and will share these boundary
% vertices. 
%
% Kevin Mattheus Moerman
% kevinmoerman@hotmail.com
% 2013/14/08
%------------------------------------------------------------------------

%% PLOT SETTINGS
if plotOn==1;     
    figColor='w'; figColorDef='white';
    fontSize=10;    
    fAlpha=1;    
    markerSize=20;       
    faceColor='r';
    hf1=figuremax(figColor,figColorDef);
    title('Smoothened triangulated mesh','FontSize',fontSize);
    xlabel('X','FontSize',fontSize);ylabel('Y','FontSize',fontSize);zlabel('Z','FontSize',fontSize);
    hold on;  
end

%% CONTROL PARAMETERS
interpMethod='pChip';
closeLoopOpt=1;

%% MESHING REGIONS

%The total vertex, face and color (=region number) matrices
V=[]; F=[]; regionInd=[];
for qRegion=1:1:numel(regionSpec)
    
    %Define region cell
    regionCell=regionSpec{qRegion};
    
    %Resampling curves
    for qCurve=1:1:numel(regionCell)
        %Calculate required number of points for curve
        np=round(max(pathLength(regionCell{qCurve}))./BoundaryPointSpacings{qRegion}{qCurve});
        [regionCell{qCurve}]=evenlySampleCurve(regionCell{qCurve},np,interpMethod,closeLoopOpt);
    end
    
    %Meshing region
    [Fs,Vs]=regionTriMesh2D(regionCell,MeshPointSpacings(qRegion),0,0);
        
    %Joining regions    
    F=[F;Fs+size(V,1)]; %Add new faces and fix vertex indices
    V=[V;Vs]; %Add points
    regionInd=[regionInd; qRegion*ones(size(Fs,1),1)]; %Create region index for faces   
end

%% PLOTTING
if plotOn==1  
    figure(hf1);
    patch('faces',F,'vertices',V,'FaceColor','flat','CData',regionInd,'FaceAlpha',fAlpha);
    colormap(autumn(numel(regionSpec))); colorbar;
    axis equal; view(2); axis tight;  set(gca,'FontSize',fontSize); grid on;
    drawnow;
end

%% REMOVING DOUBLE POINTS
%Removing double points (region curve points may appear multiple times)
[~,ind1,ind2]=unique(pround(V,5),'rows');
V=V(ind1,:); %The unique point set
F=ind2(F); %Fixing vertex indices in faces matrix
 
%% 
% ********** _license boilerplate_ **********
% 
% Copyright 2017 Kevin Mattheus Moerman
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%   http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
