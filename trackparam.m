
switch (title)      

case 'Occlusion1'; 
    p = [177,147,115,145,0];
    opt = struct('numsample',600, 'condenssig',0.25, 'ff',1, ...
                 'batchsize',5, 'affsig',[5,5,.00,.00,.00,.000]);     

case 'Occlusion2';
    p = [156,112,72,100,0.00];
    opt = struct('numsample',600, 'condenssig',0.25, 'ff',1, ...
                 'batchsize',5, 'affsig',[4, 4,.005,.012,.001,.000]);

case 'Jumping';         
p = [163,126,32,32,0];
opt = struct('numsample',600, 'condenssig',0.25, 'ff',1, ...
             'batchsize',5, 'affsig',[10,10,.000,.000,.000,.00]);      
             
case 'Caviar1';   
    p = [ 152, 68, 18, 61, 0.00 ];
    opt = struct('numsample',600, 'condenssig',0.25, 'ff',1, ...
                 'batchsize',5, 'affsig',[4,4,.03,.00,.005,.000]); 

case 'Caviar2'; 
    p = [162 216 50 140 0.0];
    opt = struct('numsample',600, 'condenssig',0.25, 'ff',1, ...
                 'batchsize',5, 'affsig',[4,4,.03,.00,.001,.0000]); 
   
case 'Car11';  p = [89 140 30 25 0];
    opt = struct('numsample',600, 'condenssig',0.2, 'ff',1, ...
                 'batchsize',5, 'affsig',[5,5,.01,.01,.001,.001]);
    
case 'DavidIndoor';  
    p = [160 112 60 92 -0.01];
    opt = struct('numsample',600, 'condenssig',0.75, 'ff',0.99, ...
                 'batchsize',5, 'affsig',[5,5,.01,.01,.001,.001]);
             
case 'DavidOutdoor'; p = [102,266,40,134,0.00];
opt = struct('numsample',300, 'condenssig',0.25, 'ff',1, ...
             'batchsize',5, 'affsig',[6,3,.00,.000,.00,.000]);      
              
otherwise;  error(['unknown title ' title]);
end

%%***************************Load Data*****************************%%
dataPath = [ 'Data\' title '\'];
%%***************************Load Data*****************************%%