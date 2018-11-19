
#include "Vtb_integration.h"
#include "verilated.h"

/*
@brief Top level simulation function.
@details Taken straight from the verilator examples.
*/
int main(int argc, char** argv, char** env) {
    
    Verilated::commandArgs(argc, argv);
    
    Vtb_integration* top        = new Vtb_integration;
    vluint64_t       main_time  = 0;       // Current simulation time

    top -> g_resetn = 0;

    while (!Verilated::gotFinish()) {

        if(main_time > 80) {
            top -> g_resetn = 1;
        }

        if((main_time % 10) == 1) {
            top -> g_clk = 1;
        } else if((main_time % 10) == 6) {
            top -> g_clk = 0;
        }

        top->eval();
        main_time ++;
    }

    delete top;
    exit(0);
}
