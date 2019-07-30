function varargout=demos(varargin)
  p = inputParser; 
  p.KeepUnmatched=true; 
  p.addParamValue('stop',false,@islogical);
  p.addParamValue('save',false,@islogical);
  p.addParamValue('pause',2,@isscalar);
  p.addParamValue('dir','./figures',@ischar);
  p.parse(varargin{:});
  stop=p.Results.stop;
  dir=p.Results.dir;ptime=p.Results.pause;
  mkdir(dir);
  SaveOptions={'format','png', 'dir',dir,'tag',true,'verbose',true};


  List={'Poisson.BVPPoisson2D_ex01','Poisson.BVPPoisson2D_ex02','Poisson.BVPPoisson2D_ex03', ...
          'Poisson.BVPPoisson3D_ex01','BVPCondenser2D01','BVPElectrostatic2D01', ...
          'BVPStationaryConvectionDiffusion2D01','BVPStationaryConvectionDiffusion3D01', ...
          'elasticity.BVPElasticity2D01','elasticity.BVPElasticity3D01', ...
          'HeatAndFlowVelocity.BVPHeatAndFlowVelocity2D01','HeatAndFlowVelocity.BVPHeatAndFlowVelocity3D01'};
      
  nL=length(List);
  valid=ones(1,nL);
  for i=1:nL
    command=sprintf('fc_vfemp1.examples.%s',List{i});
    fprintf('[fc-vfemp1] Running %s\n',command)
    try 
      eval(command)
    catch
      valid(i)=0;
      if stop
        error('[fc-vfemp1] Stop! running %s FAILED!\n',command)
      else
        warning('[fc-vfemp1] Running %s FAILED!\n',command)   
      end
    end
    drawnow
    if ptime>0, fprintf('*** Waiting %g seconds\n',ptime);pause(ptime);end
    if p.Results.save
      fprintf('Saving figures ...\n')
      fc_tools.graphics.SaveAllFigsAsFiles(List{i},SaveOptions{:})
    end
  end
  if nargout==1,varargout{1}=valid;end
end
