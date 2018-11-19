
#include "Vscarv_prv_xcrypt_top.h"
#include "verilated.h"

int main(int argc, char** argv, char** env) {
    Verilated::commandArgs(argc, argv);
    Vscarv_prv_xcrypt_top * top = new Vscarv_prv_xcrypt_top;
    while (!Verilated::gotFinish()) { top->eval(); }
    delete top;
    exit(0);
}
