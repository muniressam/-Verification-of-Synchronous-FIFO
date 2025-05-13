package shared_pkg;
    // Define the shared package here
    // This package can contain common parameters, types, and functions used across different modules
    parameter int FIFO_WIDTH = 16;
    parameter int FIFO_DEPTH = 8;

    logic test_finished;
    integer error_count=0;
    integer correct_count=0;
    event etrigger;

endpackage