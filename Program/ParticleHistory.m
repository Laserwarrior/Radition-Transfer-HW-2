function [Travel_Distance_magnitude_total_Multiple_Run, Travel_Z_direction_total_total_Multiple_Run, Current_on_right_total, First_spatial_moment_Multiple_Run] = ParticleHistory(Surface_source_flag, Material_Kind, Surface_Sources_type, Surface_Sources, Spatial_Material_Parameter, Material_End, Strength_Probablity_kind_effective, Strength_Probablity_effective)

Source_One_History_position_angle_strength_initial = Source(Surface_source_flag, Surface_Sources, Spatial_Material_Parameter, Strength_Probablity_kind_effective, Strength_Probablity_effective);

Initial_Position = Source_One_History_position_angle_strength_initial{'Position',:};
Position = Initial_Position;
Angle    = Source_One_History_position_angle_strength_initial{'Angle',:};
Strength = Source_One_History_position_angle_strength_initial{'Strength',:};

flag = [1, 1]; % first element: 1 indicate that the particle exist and still within the material; 0 particle disappears or leave the material; second element: absorbed (0) or not (1)
Travel_Distance_magnitude_total_Multiple_Run   = zeros(Material_Kind, 1); % initialize the travel distance
Travel_Z_direction_total_total_Multiple_Run = zeros(Material_Kind, 1); % initialize the travel z direction
First_spatial_moment_Multiple_Run = zeros(Material_Kind, 1); % here only works for one kind of material
Current_on_right_total = 0; % initialize the current on the right side

while sum( flag > 0 ) > 1 
    
   [flag, Travel_Distance_magnitude_total, Travel_Z_direction_total, Position, Angle, Strength, Current_right_boundary] = SingleTrack(Material_Kind, Spatial_Material_Parameter, Material_End, Position, Angle, Strength);
   
   Travel_Distance_magnitude_total_Multiple_Run = Travel_Distance_magnitude_total_Multiple_Run + Travel_Distance_magnitude_total; % 'Travel_Distance_magnitude_total' is actually not the total, it is just one single track, consider change the name later
   First_spatial_moment_Multiple_Run = First_spatial_moment_Multiple_Run + Travel_Distance_magnitude_total * (2*Position - 100)/100^2*3; % here only works for problem 2, need to change later
  
   Travel_Z_direction_total_total_Multiple_Run  = Travel_Z_direction_total_total_Multiple_Run  + Travel_Z_direction_total; % cannot only record position, because of the multiplication
   Current_on_right_total = Current_on_right_total + Current_right_boundary; 
   
   

end




end