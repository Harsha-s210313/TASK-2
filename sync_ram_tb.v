`timescale 1ns/1ps

module tb_sync_ram;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;

    // Signals
    reg clk;
    reg rst;
    reg we;
    reg re;
    reg [ADDR_WIDTH-1:0] addr;
    reg [DATA_WIDTH-1:0] write_data;
    wire [DATA_WIDTH-1:0] read_data;

    // Instantiate the DUT (Device Under Test)
    sync_ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .we(we),
        .re(re),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        we = 0;
        re = 0;
        addr = 0;
        write_data = 0;

        // Apply reset
        #10;
        rst = 0;

        // Write operations
        $display("Writing to RAM...");
        repeat (5) begin
            @(posedge clk);
            we = 1;
            re = 0;
            addr = $random % 16;
            write_data = $random % 256;
            $display("Write: addr = %0d, data = %0d", addr, write_data);
        end
        @(posedge clk);
        we = 0;

        // Read operations
        $display("Reading from RAM...");
        repeat (5) begin
            @(posedge clk);
            re = 1;
            addr = addr - 1;  // Just decrementing for demonstration
            #1;  // Small delay for output stabilization
            $display("Read : addr = %0d, data = %0d", addr, read_data);
        end
        @(posedge clk);
        re = 0;

        // Finish simulation
        $display("Test completed.");
        $finish;
    end

endmodule
