function [Vd,Fd]=patch_dual(V,F)

% function [Vd,Fd]=patch_dual(V,F)
% ------------------------------------------------------------------------
% Computes the dual of the input tesselation defined by the vertices V and
% faces F. 
%
%
%
% TO DO: FIX FACE NORMALS, hint use vertex/face normals duality and assume
% original F dirs are correct
%
% Kevin Mattheus Moerman
% kevinmoerman@hotmail.com
% 2014/04/28
%------------------------------------------------------------------------


%Get input tesselation vertex-normals
[~,~,Nv]=patchNormal(F,V);

%Create patch indices
[IND_F,~]=patchIND(F,V);

%Face centre point coordinates
X=V(:,1); Y=V(:,2); Z=V(:,3);
Vd=[mean(X(F),2) mean(Y(F),2) mean(Z(F),2)];

%Creating sparse arrays for faces
[I,J,v] = find(IND_F);
Xfd=accumarray({I,J},Vd(v,1),size(IND_F),[],NaN); Xfd=Xfd-nanmean(Xfd,2)*ones(1,(size(Xfd,2)));
Yfd=accumarray({I,J},Vd(v,2),size(IND_F),[],NaN); Yfd=Yfd-nanmean(Yfd,2)*ones(1,(size(Yfd,2)));
Zfd=accumarray({I,J},Vd(v,3),size(IND_F),[],NaN); Zfd=Zfd-nanmean(Zfd,2)*ones(1,(size(Zfd,2)));

%Determine face order
Xfdn=Xfd; Yfdn=Yfd; Zfdn=Zfd;
for i=1:1:size(Xfd,1)
    Vc=[Xfd(i,:); Yfd(i,:); Zfd(i,:)];
    v1=[Xfd(i,1),Yfd(i,1),Zfd(i,1)]-[Xfd(i,2),Yfd(i,2),Zfd(i,2)]; [v1]=vecnormalize(v1);
    v2=[Xfd(i,2),Yfd(i,2),Zfd(i,2)]-[Xfd(i,3),Yfd(i,3),Zfd(i,3)]; [v2]=vecnormalize(v2);
    v3=cross(v1,v2); [v3]=vecnormalize(v3);
    v2=cross(v1,v3); [v2]=vecnormalize(v2);
    DCM=[v1; v2; v3];
    Vcn=(DCM*Vc)';
    Xfdn(i,:)=Vcn(:,1);
    Yfdn(i,:)=Vcn(:,2);
    Zfdn(i,:)=Vcn(:,3);
end

%Fix face order
theta_n=atan2(Yfdn,Xfdn); %[theta_n,~,~] = cart2pol(Xfdn,Yfdn,Zfdn);
[~,J_sort]=sort(theta_n,2);
I_sort=(1:1:size(J_sort,1))'*ones(1,size(J_sort,2));
IND_sort = sub2ind(size(J_sort),I_sort,J_sort);

% Creating faces matrix
Fds=IND_F(IND_sort);

%Splitting up into seperate face types and fix face normals
n_sum=sum(Fds>0,2);
face_num_types=unique(n_sum);
face_num_types=face_num_types(face_num_types>0);
Fd=cell(1,numel(face_num_types));
for i=1:1:numel(face_num_types)
    %Get faces
    Lf=(n_sum==face_num_types(i)); %logic for current faces    
    F_now=Fds(Lf,1:face_num_types(i)); %The current face set
    
    %Flip face orientation if required
    Nv_now=Nv(Lf,:); %Appropriate face normals based on input mesh    
    [N_now]=patchNormal(F_now,Vd); %Current face normals    
    D=sqrt(sum((N_now-Nv_now).^2,2)); %Difference metric    
    logicFlip=D>1;%max(eps(N_now(:))); %Logic for faces that require flipping    
    F_now(logicFlip,:)=fliplr(F_now(logicFlip,:)); %Flip faces
    
    %Store faces in cell array    
    Fd{i}=F_now; 
end
