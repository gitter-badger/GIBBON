function Mn=dataNorm(M,normOpt)

switch normOpt
    case 1 %Using max and min
        Mn=double(M);
        Mn=Mn-min(Mn(:));
        Mn=Mn./max(Mn(:));
    case 2 %Using max only and letting M(M<0)= 0
        Mn=double(M);
        Mn(Mn<0)=0;        
        Mn=Mn./max(Mn(:));
end
 
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
