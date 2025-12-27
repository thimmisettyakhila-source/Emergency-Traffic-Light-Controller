
module tb_traffic_controller;

    reg clk, rst;
    reg emg_N, emg_E, emg_S, emg_W;

    wire N_G, N_Y, N_R;
    wire E_G, E_Y, E_R;
    wire S_G, S_Y, S_R;
    wire W_G, W_Y, W_R;

    traffic_controller DUT (
        .clk(clk), .rst(rst),
        .emg_N(emg_N), .emg_E(emg_E),
        .emg_S(emg_S), .emg_W(emg_W),
        .N_G(N_G), .N_Y(N_Y), .N_R(N_R),
        .E_G(E_G), .E_Y(E_Y), .E_R(E_R),
        .S_G(S_G), .S_Y(S_Y), .S_R(S_R),
        .W_G(W_G), .W_Y(W_Y), .W_R(W_R)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1;
        emg_N = 0; emg_E = 0; emg_S = 0; emg_W = 0;

        #10 rst = 0;

        // Ambulance from NORTH
        #10 emg_N = 1;
        #20 emg_E = 1;   // Another ambulance arrives (EAST)
        #20 emg_N = 0;   // NORTH cleared
        #20 emg_E = 0;   // EAST cleared

        // Ambulance from SOUTH
        #10 emg_S = 1;
        #20 emg_W = 1;   // WEST arrives later
        #20 emg_S = 0;
        #20 emg_W = 0;

        #20 $stop;
    end

endmodule
