function [flag, Travel_Distance_magnitude_total, Travel_Z_direction_total, Position, Angle, Strength, Current_right_boundary] = SingleTrack(Material_Kind, Spatial_Material_Parameter, Material_End, Position, Angle, Strength)

%% Determine at which material the particle is in before traveling
Right_Material_Index = find(  Spatial_Material_Parameter.Material_right_boundary >= Position   );
Current_Material_Index = Right_Material_Index(1);
Current_Material_Parameter = Spatial_Material_Parameter(Current_Material_Index,:);
intial_position_one_track = Position;
Travel_Distance_magnitude_total   = zeros(Material_Kind, 1); % initialize the travel distance
Travel_Z_direction_total = zeros(Material_Kind, 1); % initialize the travel z direction
Current_right_boundary = 0;  % initialize the current on the right boundary
flag = [1, 1]; % % first element: 1 indicate that the particle exist and still within the material; 0 particle disappears or leave the material; second element: absorbed (0) or not (1)

%% single travel
[Travel_Distance_magnitude, Position] = RayTracer(Spatial_Material_Parameter, Current_Material_Parameter, Position, Angle);

Right_Material_Index = find(  Spatial_Material_Parameter.Material_right_boundary >= Position   );
% Traveled_one_time_Material_Index = Right_Material_Index(1);
% Traveled_one_time_Material_Parameter = Spatial_Material_Parameter(Traveled_one_time_Material_Index,:);

if Position > Material_End || Position < 0 % shoot out from right/left boundary; If angle = 0, it is not possible to shoot out
    flag(1) = 0;
    if Angle > 0 % should shoot to the right ; initial angle
        Travel_Distance_magnitude_total(Current_Material_Index) = Travel_Distance_magnitude_total(Current_Material_Index) + abs((Spatial_Material_Parameter.Material_right_boundary(Current_Material_Index) - intial_position_one_track)/Angle);
        Travel_Z_direction_total(Current_Material_Index) = Travel_Z_direction_total(Current_Material_Index) + Spatial_Material_Parameter.Material_right_boundary(Current_Material_Index) - intial_position_one_track;
        
        if Current_Material_Index < Material_Kind
        Travel_Distance_magnitude_total(Current_Material_Index+1:end) = Travel_Distance_magnitude_total(Current_Material_Index+1:end) + abs(Spatial_Material_Parameter.Thickness(Current_Material_Index+1:end)/Angle);
        Travel_Z_direction_total(Current_Material_Index+1:end) = Travel_Z_direction_total(Current_Material_Index+1:end) + Spatial_Material_Parameter.Thickness(Current_Material_Index+1:end);
        end
        
        Current_right_boundary = Strength;
        Position = 100;
    else
        Travel_Distance_magnitude_total(Current_Material_Index) = Travel_Distance_magnitude_total(Current_Material_Index) + abs( (Spatial_Material_Parameter.Thickness(Current_Material_Index) - (Spatial_Material_Parameter.Material_right_boundary(Current_Material_Index) - intial_position_one_track ) ) / Angle);
        Travel_Z_direction_total(Current_Material_Index) = Travel_Z_direction_total(Current_Material_Index) - abs(Spatial_Material_Parameter.Thickness(Current_Material_Index) - (Spatial_Material_Parameter.Material_right_boundary(Current_Material_Index) - intial_position_one_track ) );
        
        if  Current_Material_Index > 1
            Travel_Distance_magnitude_total(Current_Material_Index-1:1) = Travel_Distance_magnitude_total(Current_Material_Index-1:1) + abs(Spatial_Material_Parameter.Thickness(Current_Material_Index-1:1)/Angle);
            Travel_Z_direction_total(Current_Material_Index-1:1) = Travel_Z_direction_total(Current_Material_Index-1:1) - abs(Spatial_Material_Parameter.Thickness(Current_Material_Index-1:1));
        end
        Position = 0;
    end
    
else% still within material
        Traveled_one_time_Material_Index = Right_Material_Index(1);
        Traveled_one_time_Material_Parameter = Spatial_Material_Parameter(Traveled_one_time_Material_Index,:);
        Number_of_Material_Crossed = abs(Traveled_one_time_Material_Index - Current_Material_Index);
        
        if Angle > 0
        
            if Current_Material_Index == Traveled_one_time_Material_Index
                Travel_Distance_magnitude_total(Current_Material_Index) =  Travel_Distance_magnitude_total(Current_Material_Index) + Travel_Distance_magnitude;
                Travel_Z_direction_total(Current_Material_Index)        =  Travel_Z_direction_total(Current_Material_Index) + (Position - intial_position_one_track);
        
            else
                Travel_Distance_magnitude_total(Current_Material_Index) = Travel_Distance_magnitude_total(Current_Material_Index) + abs((Spatial_Material_Parameter.Material_right_boundary(Current_Material_Index) - intial_position_one_track)/Angle);
                Travel_Distance_magnitude_total(Traveled_one_time_Material_Index) = Travel_Distance_magnitude_total(Traveled_one_time_Material_Index) + abs( ( Position - Spatial_Material_Parameter.Material_right_boundary(Traveled_one_time_Material_Index-1) )/Angle );
    
                Travel_Z_direction_total(Current_Material_Index) = Travel_Z_direction_total(Current_Material_Index) + abs( Spatial_Material_Parameter.Material_right_boundary(Current_Material_Index) - intial_position_one_track );
                Travel_Z_direction_total(Traveled_one_time_Material_Index) = Travel_Z_direction_total(Traveled_one_time_Material_Index) + abs( Position - Spatial_Material_Parameter.Material_right_boundary(Traveled_one_time_Material_Index-1) ); % if it is different, then there is at least two materials. So, the '-1' is valid 
                
                if  Number_of_Material_Crossed > 1 
                    Travel_Distance_magnitude_total(Current_Material_Index+1:Traveled_one_time_Material_Index-1) = Travel_Distance_magnitude_total(Current_Material_Index+1:Traveled_one_time_Material_Index-1) + abs(Spatial_Material_Parameter.Thickness(Current_Material_Index+1:Traveled_one_time_Material_Index-1)/Angle);
                    Travel_Z_direction_total(Current_Material_Index+1:Traveled_one_time_Material_Index-1) = Travel_Z_direction_total(Current_Material_Index+1:Traveled_one_time_Material_Index-1) + abs(Spatial_Material_Parameter.Thickness(Current_Material_Index+1:Traveled_one_time_Material_Index-1));
                end
            end
            
        elseif Angle < 0
            
            if  Current_Material_Index == Traveled_one_time_Material_Index
                Travel_Distance_magnitude_total(Current_Material_Index) =  Travel_Distance_magnitude_total(Current_Material_Index) + Travel_Distance_magnitude;
                Travel_Z_direction_total(Current_Material_Index)        =  Travel_Z_direction_total(Current_Material_Index) + (Position - intial_position_one_track);
            else
                Travel_Distance_magnitude_total(Current_Material_Index) = Travel_Distance_magnitude_total(Current_Material_Index) + abs((Spatial_Material_Parameter.Thickness(Current_Material_Index) - (Spatial_Material_Parameter.Material_right_boundary(Current_Material_Index) - intial_position_one_track))/Angle);
                Travel_Distance_magnitude_total(Traveled_one_time_Material_Index) = Travel_Distance_magnitude_total(Traveled_one_time_Material_Index) + abs( ( Position - Spatial_Material_Parameter.Material_right_boundary(Traveled_one_time_Material_Index))/Angle);
    
                Travel_Z_direction_total(Current_Material_Index) = Travel_Z_direction_total(Current_Material_Index) - abs( Spatial_Material_Parameter.Material_right_boundary(Current_Material_Index-1) - intial_position_one_track );
                Travel_Z_direction_total(Traveled_one_time_Material_Index) = Travel_Z_direction_total(Traveled_one_time_Material_Index) - abs( Position - Spatial_Material_Parameter.Material_right_boundary(Traveled_one_time_Material_Index) );
                
                if  Number_of_Material_Crossed > 1 
                    Travel_Distance_magnitude_total(Traveled_one_time_Material_Index+1:Current_Material_Index-1) = Travel_Distance_magnitude_total(Traveled_one_time_Material_Index+1:Current_Material_Index-1) + abs(Spatial_Material_Parameter.Thickness(Traveled_one_time_Material_Index+1:Current_Material_Index-1)/Angle);
                    Travel_Z_direction_total(Traveled_one_time_Material_Index+1:Current_Material_Index-1) = Travel_Z_direction_total(Traveled_one_time_Material_Index+1:Current_Material_Index-1) - abs(Spatial_Material_Parameter.Thickness(Traveled_one_time_Material_Index+1:Current_Material_Index-1));
                end
            end
            
        else % angle = 0
            Travel_Distance_magnitude_total(Current_Material_Index) =  Travel_Distance_magnitude_total(Current_Material_Index) + Travel_Distance_magnitude;
        end
        
        %% reaction after single travel
        % Angle accumulation considered
        [Angle_addition, Strength, flag_2] = ReactionGeneration(Traveled_one_time_Material_Parameter, Strength);
        
         Angle_theta = acos(Angle) + acos(Angle_addition); % It is the theta, not the cos(theta)
         
         if Angle_theta > pi
           Angle = cos(Angle_theta - pi);
           tf = isreal(Angle);
           if ~tf
                warning('something wrong with the reaction after single travel!');
           end
         elseif Angle_theta < 0
           Angle = cos(Angle_theta + pi);
           tf = isreal(Angle);
           if ~tf
             warning('something wrong with the reaction after single travel!');
           end
         else
             Angle = cos(Angle_theta);
         end
         
         
         flag(2) = flag_2;
         
         % don't consider the angle accumulation
%        Angle = Angle_addition;
%        flag(2) = flag_2;
end

Travel_Distance_magnitude_total = Travel_Distance_magnitude_total * Strength;
Travel_Z_direction_total = Travel_Z_direction_total * Strength;


end