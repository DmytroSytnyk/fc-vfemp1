function [conffile,isFileExists]=getLocalConfFile()
  fullname=mfilename('fullpath');
  I=strfind(fullname,filesep);
  Path=fullname(1:(I(end-1)-1));
  conffile=[Path,filesep,'configure_loc.m'];
  [fid,message]=fopen(conffile,'r');
  if ( fid == -1 ), isFileExists=false;else isFileExists=true;fclose(fid); end
end