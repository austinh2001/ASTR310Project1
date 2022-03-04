function cnt=wpad(h,str)
    % Provided to TEAM CANS via the Astronomy Department of the University of Maryland
    
    % Pad lines to be 80 chars long.
    % Deal with lines that are longer and need to be split
    % into several "CONTINUE" lines.
    
    cnt=0;
    if (~isempty(str)),
        if (length(str)<=80),
            str=[str,blanks(80)];
            str=str(1:80);
            fprintf(h,'%s',str);
            cnt=80;
        else
            done=0;
            ixs=1;
            ixe=78;
            fprintf(h,'%s',[str(ixs:ixe),'&''']);
            lstr=length(str);
            cnt=cnt+80;
            while (~done),
                ixs=ixe+1;
                if (lstr-ixe<69),
                    u=[str(ixs:end),blanks(80)];
                    fprintf(h,'CONTINUE= ''%s',u(1:69));
                    done=1;
                    cnt=cnt+80;
                else
                    ixe=ixs+66;
                    fprintf(h,'CONTINUE= ''%s&''',str(ixs:ixe));
                    cnt=cnt+80;
                end
            end
        end     
    end
    return
end