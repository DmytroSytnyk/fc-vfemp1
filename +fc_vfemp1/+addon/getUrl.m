function urlbase=getUrl()
  if fc_tools.comp.isOctave()
    urlbase='http://www.math.univ-paris13.fr/~cuvelier/software/codes/Octave/fc-vfemp1/addon/';
  else
    urlbase='http://www.math.univ-paris13.fr/~cuvelier/software/codes/Matlab/fc-vfemp1/addon/';
  end
end