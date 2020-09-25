function kin = mergekinematicsfiles(infiles,outfile,varargin)

opt.redo = false;
opt.savemidlines = false;
opt.goodwavepts = 3:17;
opt.handleduplicates = 'off';
opt.dssmoothcurve = 0;
opt.nsmoothcurve = 0;

p = 1;
while (p <= length(varargin)),
    switch lower(varargin{p}),
      case {'redo','savemidlines'},
        opt.(lower(varargin{p})) = true;
        p = p+1;

      case {'goodwavepts','handleduplicates','dssmoothcurve','nsmoothcurve'},
        opt.(lower(varargin{p})) = varargin{p+1};
        p = p+2;
        
      otherwise,
        error('Unrecognized option %s',varargin{p});
    end;
end;

if (isempty(infiles)),
    [fn,pn] = uigetfile('*.mat','Select input files','MultiSelect','on');
    infiles = cellfun(@(x) (fullfile(pn,x)), fn, 'UniformOutput',false);
else
    [pn,fn,ext] = fileparts(infiles{1});
end;

if (nargin <= 1)
    outfile = '';
end;

if ((nargout == 0) && isempty(outfile)),
    [fn,pn] = uiputfile(fullfile(pn,'*.mat'),'Select output file');
end;

nfiles = length(infiles);

%disable warnings for variables not found in a .mat file - we'll handle the problem
%ourselves
warnstate = warning('off','MATLAB:load:variableNotFound');
goodfiles = true(size(infiles));

basevars = {'fishlenmm','smm','t','mxmm','mymm',...
                 'humms','hvmms','width','avifile','fr' };
kinvars = { 'indpeak','per','amp','wavevel','wavelen' };

duplicate = cell(2,nfiles);

for f = 1:nfiles,
    fprintf('File %s...\n', infiles{f});
    
    if (opt.redo),
        F = load(infiles{f},basevars{:});
        
        if (length(fieldnames(F)) < length(basevars)),
            warning('File %s does not have the correct variables. Skipping.',infiles{f});
            bybeat(f).goodfiles = false;
            byframe(f).goodfiles = false;
            continue;
        end;

        [F.indpeak,conf,F.per,F.amp,midx,midy,exc,F.wavevel,F.wavelen] = ...
            analyzeKinematics(F.smm,F.t,F.mxmm,F.mymm,'goodwavepts',opt.goodwavepts, ...
                              'dssmoothcurve',opt.dssmoothcurve,...
                              'nsmoothcurve',opt.nsmoothcurve);
    else
        F = load(infiles{f},basevars{:},kinvars{:});
        
        if (length(fieldnames(F)) < length(basevars)+length(kinvars)),
            warning('File %s does not have the correct variables. Skipping.',infiles{f});
            bybeat(f).goodfiles = false;
            byframe(f).goodfiles = false;
            continue;
        end;
    end;
    
    duplicate{1,f} = F.avifile;
    duplicate{2,f} = F.fr;

    curve = curvature(F.mxmm,F.mymm,'spline','smooth',opt.dssmoothcurve);
    pkcurve0 = NaN(size(F.indpeak));
    pt = repmat((1:size(F.indpeak,1))',[1 size(F.indpeak,2)]);
    good = isfinite(F.indpeak);
    pkind = sub2ind(size(curve),pt(good),F.indpeak(good));
    pkcurve0(good) = curve(pkind);
    pkcurve = max(pkcurve0);
    pkcurvemin = min(pkcurve0);
    
    good = -pkcurvemin > pkcurve;
    pkcurve(good) = pkcurvemin(good);
    
    bybeat(f).len = F.fishlenmm;
    
    npts = size(F.mxmm,1);
    
    [ha,ind] = first(F.amp,isfinite(F.amp));
    ha(ind > 5) = NaN;
    bybeat(f).headamp = ha(:) / F.fishlenmm;
    bybeat(f).midamp = F.amp(round(npts/2),:)' / F.fishlenmm;
    bybeat(f).tailamp = F.amp(end,:)' / F.fishlenmm;
    bybeat(f).freq = nanmedian(1./F.per)';
    bybeat(f).wavelen = nanmedian(F.wavelen(opt.goodwavepts,:))' / F.fishlenmm;
    bybeat(f).wavespeed = F.wavevel' / F.fishlenmm;
    bybeat(f).curvepeak = pkcurve(:);
    bybeat(f).goodfiles = true;
    
    [comx,comy] = ctrofmasspos(F.mxmm,F.mymm,F.width*F.fishlenmm);

    comvx = deriv(F.t,comx,2);
    comvy = deriv(F.t,comy,2);

    comspeed = sqrt(comvx.^2 + comvy.^2);
    
    ind1 = F.indpeak(end,:);
    ind1 = ind1(isfinite(ind1));
    ind = [0 (ind1(1:end-1)+ind1(2:end))/2 length(F.humms)];
    ind = round(ind);
    v1 = nans(size(F.indpeak,2),1);
    for j = 1:length(ind)-1,
        v1(j) = nanmean(comspeed(ind(j)+1:ind(j+1)));
    end;
    
    bybeat(f).comspeed = v1 / F.fishlenmm;
    
    if (opt.savemidlines),
        byframe(f).goodfiles = true;
        byframe(f).comspeed = comspeed(:)';
        byframe(f).mx = F.mxmm ./ F.fishlenmm;
        byframe(f).my = F.mymm ./ F.fishlenmm;
        byframe(f).t = F.t;
        byframe(f).curve = curve ./ F.fishlenmm;
    end;
end;

%re-enable warnings
warning(warnstate);

if (~strcmp(opt.handleduplicates,'off')),
    isduplicate = false(1,nfiles);
    duplicatenum = zeros(1,nfiles);
    
    numfr = cellfun(@length,duplicate(2,:));
    names = duplicate(1,:);
    names = cellfun(@char,names,'UniformOutput',false);
   
    for i = 1:nfiles,
        if (isduplicate(i)),
            continue;
        end;
        
        samenumframes = numfr(i) == numfr(:);
        samenumframes(i) = false;
        
        sameframes = false(1,nfiles);
        if (any(samenumframes) && (numfr(i) > 0)),
            sameframes(samenumframes) = ...
                all(repmat(duplicate{2,i},[sum(samenumframes) 1]) == ...
                    cat(1,duplicate{2,samenumframes}), 2);
        end;
        
        k = strmatch(names{i},names,'exact');
        k = k(k ~= i);
        
        sameavi = false(1,nfiles);
        sameavi(k) = true;
        
        isduplicate(sameavi & sameframes) = true;
        duplicatenum(sameavi & sameframes) = i;
    end;
end;
        
fn = fieldnames(bybeat);
C1 = struct2cell(bybeat);

len = cellfun(@(x) (size(x,1)),C1);

C2 = cell(length(fn),1);
for i = 1:length(fn),
    len1 = max(len(i,:));
    
    a = NaN(len1,nfiles);
    for j = 1:nfiles,
        a(1:length(C1{i,j}),j) = C1{i,j};
    end;
    C2{i} = a;
end;

kin = cell2struct(C2,fn,1);

if (opt.savemidlines),
    fn = fieldnames(byframe);
    C1 = struct2cell(byframe);
    
    s1 = cellfun(@(x) (size(x,1)), C1);
    s2 = cellfun(@(x) (size(x,2)), C1);
    
    C2 = cell(length(fn),1);
    for i = 1:length(fn),
        if (any(s2(i,:) > 1)),
            a = NaN(max(s1(i,:)),max(s2(i,:)),nfiles);
            
            for j = 1:nfiles,
                if (~isempty(C1{i,j})),
                    a(1:size(C1{i,j},1),1:size(C1{i,j},2),j) = C1{i,j};
                end;
            end;
        else
            a = NaN(max(s1(i,:)),nfiles);
            
            for j = 1:nfiles,
                a(1:size(C1{i,j},1),j) = C1{i,j};
            end;
        end;
        C2{i} = a;
    end;
    
    mid = cell2struct(C2,fn,1);
    
    kin.mid = mid;
end;

kin.files = infiles;

if (~isempty(outfile)),
    save(outfile,'-struct','kin');
end;

warning(warnstate);



    