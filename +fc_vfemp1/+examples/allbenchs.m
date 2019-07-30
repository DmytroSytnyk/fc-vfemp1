clear all
close all

debug=true;
save=false;
force=true;
tag=true;
speed=true;
options={'debug',debug,'save',save,'force',force,'tag',tag,'perm',@(A) colamd(A)};

if speed, LN=10:10:40;else LN=100:100:400;end

setBVP=@(N,verbose) fc_vfemp1.examples.Poisson.setBVPPoisson2D_ex01(N,verbose);
fc_vfemp1.examples.bench('setBVP',setBVP,'LN',LN,options{:});

setBVP=@(N,verbose) fc_vfemp1.examples.Poisson.setBVPPoisson2D_ex02(N,verbose);
fc_vfemp1.examples.bench('setBVP',setBVP,'LN',LN,options{:});

setBVP=@(N,verbose) fc_vfemp1.examples.Poisson.setBVPPoisson2D_ex03(N,verbose);
fc_vfemp1.examples.bench('setBVP',setBVP,'LN',LN,options{:});

if speed, LN=2:2:10;else LN=5:5:30;end

setBVP=@(N,verbose) fc_vfemp1.examples.Poisson.setBVPPoisson3D_ex01(N,verbose);
fc_vfemp1.examples.bench('setBVP',setBVP,'LN',LN,options{:});

setBVP=@(N,verbose) fc_vfemp1.examples.setBVPCondenser2D01(N,verbose);
fc_vfemp1.examples.bench('setBVP',setBVP,'LN',LN,options{:});

setBVP=@(N,verbose) fc_vfemp1.examples.setBVPElectrostatic2D01(N,verbose);
fc_vfemp1.examples.bench('setBVP',setBVP,'LN',LN,options{:});

setBVP=@(N,verbose) fc_vfemp1.examples.setBVPStationaryConvectionDiffusion2D01(N,verbose);
fc_vfemp1.examples.bench('setBVP',setBVP,'LN',LN,options{:});

setBVP=@(N,verbose) fc_vfemp1.examples.elasticity.setBVPElasticity2D01(N,verbose);
fc_vfemp1.examples.bench('setBVP',setBVP,'LN',LN,options{:});

setBVP=@(N,verbose) fc_vfemp1.examples.elasticity.setBVPElasticity2D_ex01(N,verbose);
fc_vfemp1.examples.bench('setBVP',setBVP,'LN',LN,options{:});

if speed, LN=5:2:13;else LN=5:5:30;end

setBVP=@(N,verbose) fc_vfemp1.examples.setBVPStationaryConvectionDiffusion3D01(N,verbose);
fc_vfemp1.examples.bench('setBVP',setBVP,'LN',LN,options{:});

setBVP=@(N,verbose) fc_vfemp1.examples.elasticity.setBVPElasticity3D01(N,verbose);
fc_vfemp1.examples.bench('setBVP',setBVP,'LN',LN,options{:});





