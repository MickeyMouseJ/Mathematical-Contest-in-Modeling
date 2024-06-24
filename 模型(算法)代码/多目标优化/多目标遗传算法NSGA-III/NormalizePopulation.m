function [pop, params] = NormalizePopulation(pop, params)
%归一化处理
    params.zmin = UpdateIdealPoint(pop, params.zmin);
    
    fp = [pop.Cost] - repmat(params.zmin, 1, numel(pop));%减去最小值
    
    params = PerformScalarizing(fp, params);%
    
    a = FindHyperplaneIntercepts(params.zmax);
    
    for i = 1:numel(pop)
        pop(i).NormalizedCost = fp(:, i)./a;%标准化后的目标值
    end
    
end

function a = FindHyperplaneIntercepts(zmax)

    w = ones(1, size(zmax, 2))/zmax;
    
    a = (1./w)';

end