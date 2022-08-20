function split_file(source, Nmax)

    file = fopen(source, 'r+');

    lines = {};
    lines{end+1} = fgetl(file);
        
    while ischar(lines{end})
        lines{end+1} = fgetl(file);
    end
    
    fclose(file);
        
    if (length(lines) <= Nmax)
        return;
    end
        
    F = ceil(length(lines) / Nmax);
    
    [folder, name, ~] = fileparts(source);
        
    for f = [1 : 1 : F]
                
        path = sprintf('%s/%s-%d.tap', folder, name, f);
        
        disp(path);
        
        Lmax = Nmax * f;
        
        if (Lmax > length(lines)-1)
            Lmax = length(lines)-1;
        end
                
        file = fopen(path, 'w');
        
        for n = [Nmax * (f - 1) + 1 : 1 : Lmax]
            
            fprintf(file, strcat(lines{n}, '\n'));
        end
        
        fclose(file);
    end
    
    delete(source);
end