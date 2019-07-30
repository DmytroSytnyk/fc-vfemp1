function print_info(info)
  for i=1:length(info.tcpu)
    fprintf('    -> %20s in : %.3f(s)\n',info.tname{i},info.tcpu(i));
  end
end