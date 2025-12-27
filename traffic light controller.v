module traffic_controller (
    input clk,
    input rst,

    // Emergency signals
    input emg_N,
    input emg_E,
    input emg_S,
    input emg_W,

    // Traffic light outputs
    output reg N_G, N_Y, N_R,
    output reg E_G, E_Y, E_R,
    output reg S_G, S_Y, S_R,
    output reg W_G, W_Y, W_R
);

    // Direction encoding
    parameter NORTH = 2'b00,
              EAST  = 2'b01,
              SOUTH = 2'b10,
              WEST  = 2'b11;

    reg emergency_active;
    reg [1:0] current_dir;

    // Emergency detection (FCFS)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            emergency_active <= 0;
            current_dir <= NORTH;
        end
        else begin
            if (!emergency_active) begin
                if (emg_N) begin
                    emergency_active <= 1;
                    current_dir <= NORTH;
                end
                else if (emg_E) begin
                    emergency_active <= 1;
                    current_dir <= EAST;
                end
                else if (emg_S) begin
                    emergency_active <= 1;
                    current_dir <= SOUTH;
                end
                else if (emg_W) begin
                    emergency_active <= 1;
                    current_dir <= WEST;
                end
            end
            else begin
                // Clear emergency after signal goes low
                case (current_dir)
                    NORTH: if (!emg_N) emergency_active <= 0;
                    EAST : if (!emg_E) emergency_active <= 0;
                    SOUTH: if (!emg_S) emergency_active <= 0;
                    WEST : if (!emg_W) emergency_active <= 0;
                endcase
            end
        end
    end

    // Traffic light control
    always @(*) begin
        // Default: all RED
        N_G=0; N_Y=0; N_R=1;
        E_G=0; E_Y=0; E_R=1;
        S_G=0; S_Y=0; S_R=1;
        W_G=0; W_Y=0; W_R=1;

        if (emergency_active) begin
            case (current_dir)
                NORTH: begin N_G=1; N_R=0; end
                EAST : begin E_G=1; E_R=0; end
                SOUTH: begin S_G=1; S_R=0; end
                WEST : begin W_G=1; W_R=0; end
            endcase
        end
    end

endmodule

