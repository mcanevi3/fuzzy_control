function vec=profile_generator(points,xvec,yvec)
    vec = zeros(size(points));
    for j = 1:length(points)
        tval = points(j);
        yval = 0;

        % Check if tval matches exactly any xvec point
        matched = false;
        for i = 1:length(xvec)
            if tval == xvec(i)
                yval = yvec(i);
                matched = true;
                break;
            end
        end

        if matched
            vec(j) = yval;
            continue;
        end

        % Check if tval lies between two xvec points
        for i = 1:length(xvec)-1
            x1 = xvec(i);   x2 = xvec(i+1);
            y1 = yvec(i);   y2 = yvec(i+1);

            if tval > x1 && tval < x2
                % Manual linear interpolation formula
                yval = y1 + (y2 - y1) * (tval - x1) / (x2 - x1);
                break;
            end
        end

        vec(j) = yval;
    end

end