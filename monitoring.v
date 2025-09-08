module monitoring(
    input clk,
    input ir,
    input gas_in,
    input fire,
    input reset,
    input reset1,

    output buzzer,
    output led1,
    output led2,
    output [13:0] count,
    output [7:0] ca,
    output [3:0] an,

    output IN1,
    output IN2
    
);

    // Instantiate final module
    final f1 (
        .clk(clk),
        .ir(ir),
        .gas_in(gas_in),
        .fire(fire),
        .reset(reset),
        .reset1(reset1),
        .buzzer(buzzer),
        .led1(led1),
        .led2(led2),
        .count(count)
        );

    // Instantiate motor driver control module
    motor m1 (
        .clk(clk),
        .fire_in(fire),
        .IN1(IN1),
        .IN2(IN2)
        
    );

    // Segment display
    seg_display_mux_4digit display_mux (
        .clk(clk),
        .count(count),
        .ca(ca),
        .an(an)
    );

endmodule

// final.v
module final(input clk,ir,gas_in,fire,reset,reset1,output reg buzzer,led1,led2,output reg [13:0] count);

always@(posedge clk) begin
    if(gas_in)
        led1 = 0;
    else
        led1 = 1;
end

reg [31:0] count1 = 0;
reg clk1 = 0;
always@(posedge clk) begin
    if(count1 == 25000000) begin
        count1 <= 0;
        clk1 <= ~clk1;
    end else begin
        count1 <= count1 + 1;
    end
end

reg countup;
always @(posedge clk1) begin
    if (ir == 0)
        countup <= 1;
    else 
        countup <= 0;
end

always @(posedge clk1) begin
    if (reset)
        count <= 0;
    else if (countup == 1 && count < 9999)
        count <= count + 1;
end

always @(posedge clk) begin
    if(reset1)
        led2 <= 0;
    else if(gas_in == 0)
        led2 <= 1;
    else
        led2 <= 0;
end

always @(posedge clk1) begin
    if (fire == 0)
        buzzer <= 1;
    else 
        buzzer <= 0;
end
endmodule


module seg_display_mux_4digit(
    input clk,
    input [13:0] count,
    output reg [7:0] ca,
    output reg [3:0] an
);

    reg [31:0] count_seg = 0;
    reg clk_seg = 0;
    always @(posedge clk) begin
        if (count_seg == 50000) begin
            count_seg <= 0;
            clk_seg <= ~clk_seg;
        end else begin
            count_seg <= count_seg + 1;
        end
    end

    reg [1:0] digit_sel = 0;
    wire [3:0] d0, d1, d2, d3;

    assign d0 = count % 10;
    assign d1 = (count / 10) % 10;
    assign d2 = (count / 100) % 10;
    assign d3 = (count / 1000) % 10;

    wire [7:0] ca0, ca1, ca2, ca3;

    seg_encoder seg0_enc(.val(d0), .ca(ca0));
    seg_encoder seg1_enc(.val(d1), .ca(ca1));
    seg_encoder seg2_enc(.val(d2), .ca(ca2));
    seg_encoder seg3_enc(.val(d3), .ca(ca3));

    always @(posedge clk_seg) begin
        digit_sel <= digit_sel + 1;
        case (digit_sel)
            2'b00: begin ca = ca0; an = 4'b0001; end
            2'b01: begin ca = ca1; an = 4'b0010; end
            2'b10: begin ca = ca2; an = 4'b0100; end
            2'b11: begin ca = ca3; an = 4'b1000; end
        endcase
    end

endmodule

// seg_encoder.v
module seg_encoder(
    input [3:0] val,
    output reg [7:0] ca
);
    always @(*) begin
        case (val)
    0:ca=8'b00000011;
    1:ca=8'b10011111;
    2:ca=8'b00100101;
    3:ca=8'b00001101;
    4:ca=8'b10011001;
    5:ca=8'b01001001;
    6:ca=8'b01000001;
    7:ca=8'b00011111;
    8:ca=8'b00000001;
    9:ca=8'b00001001;
    default:ca=8'b00000011;
        endcase
    end
endmodule
module motor(
    input clk,
    input fire_in,   // fire sensor input
    output reg IN1, 
    output reg IN2
    
); 

always @(posedge clk) begin
    if (fire_in==0) begin
        // Fire detected: stop motor
        IN1 <= 0;
        IN2 <= 0;
//       
    end else begin
        // No fire: run motor forward
        IN1 <= 1;
        IN2 <= 0;
//        
    end
end

endmodule