function [Source_One_History_position_angle_strength_initial] = Source(Surface_source_flag, Surface_Sources, Spatial_Material_Parameter, Strength_Probablity_kind_effective, Strength_Probablity_effective);

% Source_type_Random_Number = rand;

Number_of_Probablity_Region = length(Strength_Probablity_effective);


Accumulative_Probablity = 0;

Source_type_Random_Number = rand;

for i = 1: Number_of_Probablity_Region
    
    index = i;
    
    Accumulative_Probablity = Accumulative_Probablity + Strength_Probablity_effective(i);

    if Source_type_Random_Number <= Accumulative_Probablity
        Source_type_One_History_type = Strength_Probablity_kind_effective.Row(i);
        break;
    end
    
   
end


if Surface_source_flag && index == 1 % surface source 
    
    Source_parameter_One_History = Surface_Sources(Source_type_One_History_type,:);
    
    Range_of_Omega_z = char( Source_parameter_One_History.(1) ); % str2func(char(Surface_Sources{'Isotropic','Function'}))
    phi = str2func( char ( Source_parameter_One_History.(2) ) ); % str2func(char(Surface_Sources{'Isotropic','Function'}))

    if strcmp(Range_of_Omega_z, 'None')
        Omega_z = -1 + 2*rand;
    else
        larger_position  = strfind(Range_of_Omega_z,'>'); % can be modified later to be more general
        Omega_z_min = str2double( Range_of_Omega_z(larger_position + 1:end) );
        Omega_z = (1 - Omega_z_min)*rand + Omega_z_min;   
    end
    
    if strcmp(char(Source_type_One_History_type), 'Discrete') % Different from previous strength when comparing with the volumetric source, this strength is just for one direction
        One_History_Strength = 1;
        Omega_z = 1;
    else
        One_History_Strength = phi(Omega_z);
    end
    
    Source_One_History_position_angle_strength_name = {'Position'; 'Angle'; 'Strength'};
    Source_One_History_position_angle_strength_value = [0; Omega_z; One_History_Strength];
    Source_One_History_position_angle_strength_initial = table(Source_One_History_position_angle_strength_value, 'RowNames', Source_One_History_position_angle_strength_name);

else % volumetric source. 
    
    Source_parameter_One_History = Spatial_Material_Parameter(Source_type_One_History_type,:);
    One_History_Strength = Source_parameter_One_History.Q_0;
    One_History_Position = rand*Source_parameter_One_History.Thickness + Source_parameter_One_History.Material_right_boundary - Source_parameter_One_History.Thickness;
    if Source_parameter_One_History.Q_1 == 0
        Omega_z = -1 + 2*rand;
    else
        Source_Moment = Source_parameter_One_History(:,{'Q_0','Q_1'});
        Omega_z = RandomNumber(Source_Moment);
    end
    
    Source_One_History_position_angle_strength_name = {'Position'; 'Angle'; 'Strength'};
    Source_One_History_position_angle_strength_value = [One_History_Position; Omega_z; One_History_Strength];
    Source_One_History_position_angle_strength_initial = table(Source_One_History_position_angle_strength_value, 'RowNames', Source_One_History_position_angle_strength_name);

end


%%% test single run in main function
% x = table(Source_type_Random_Number,'RowNames',Source_type_One_History_type);

% %% test for random generator within the this sub function
% for j = 1:100 
%     
%     Source_type_Random_Number(j) = rand;
% 
% for i = 1: Number_of_Probablity_Region
%     
%     Accumulative_Probablity = Accumulative_Probablity + Strength_Probablity_effective(i);
% 
%     if Source_type_Random_Number(j) < Accumulative_Probablity
%         Source_type_One_History(j) = Strength_Probablity_kind_effective.Row(i);
%         break;
%     end
%    
% end
%      Accumulative_Probablity = 0;
% end


end