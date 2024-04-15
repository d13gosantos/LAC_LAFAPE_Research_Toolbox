function fault = offsetfault(~,t,tfault,sensors,alpha,~)
    len_sensors = length(sensors);
    len_alpha = length(alpha);
    alphaf = zeros(len_alpha,1);
     for i = 1:len_sensors
        if t >= tfault(i)
           alphaf(sensors(i)) = alpha(sensors(i));
        else
            alphaf(sensors(i)) = 0;
        end
     end
    fault = reshape(alphaf,[len_alpha 1]);
end

