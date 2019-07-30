function [default_geodir,default_meshdir] = default_directories(type)
  env=fc_vfemp1.environment();
  switch type
    case 2
      default_geodir=[env.Path,filesep,'geodir',filesep,'2d'];
      default_meshdir=[env.Path,filesep,'meshes',filesep,'2d'];
    case 2.5
      default_geodir=[env.Path,filesep,'geodir',filesep,'3ds'];
      default_meshdir=[env.Path,filesep,'meshes',filesep,'3ds'];
    case 3
      default_geodir=[env.Path,filesep,'geodir',filesep,'3d'];
      default_meshdir=[env.Path,filesep,'meshes',filesep,'3d'];
    otherwise
      default_geodir='.';
      default_meshdir='.';
  end
end