
#include <map>
#include <queue>
#include <iostream>

#include "Vscarv_prv_xcrypt_top.h"
#include "verilated.h"

//! Maximum runtime for the simulation
const vluint64_t    max_time    = 30000;

//! Typedef for the top level module of the design.
typedef Vscarv_prv_xcrypt_top* top_module_t;

//! Typedef for read request queues.
typedef std::queue<vluint32_t> read_req_queue_t;

//! Represents a single write request
typedef struct {
    vluint32_t waddr; // word aligned address to write too
    vluint32_t wdata; // write data
    vluint8_t  wstrb; // write byte enable.
} write_request_t;

//! Typedef for write request queues.
typedef std::queue<write_request_t> write_req_queue_t;

//! Main memory - modelled as sparse array.
std::map<vluint32_t, vluint8_t> main_memory;

//! List of read requests to the picorv interface
read_req_queue_t prv_read_requests;

//! List of read requests to the co-processor interface
read_req_queue_t cop_read_requests;

//! List of write requests to the picorv interface
write_req_queue_t prv_write_requests;

//! List of write requests to the co-processor interface
write_req_queue_t cop_write_requests;

/*
@brief Read a word of memory at the supplied address.
@details Un-accessed elements of memory are returned with zero values.
*/
vluint32_t mem_read_word (vluint32_t addr) {
    vluint32_t tr = 0;

    if(main_memory.find(addr+3) != main_memory.end()) {
        tr |= main_memory[addr+3];
    }
    tr = tr << 8;
    if(main_memory.find(addr+2) != main_memory.end()) {
        tr |= main_memory[addr+2];
    }
    tr = tr << 8;
    if(main_memory.find(addr+1) != main_memory.end()) {
        tr |= main_memory[addr+1];
    }
    tr = tr << 8;
    if(main_memory.find(addr+0) != main_memory.end()) {
        tr |= main_memory[addr+0];
    }
    
    return tr;
}

/*
@brief Handle an AXI read channel request.
*/
void axi_read_channel_request(
    vluint8_t  * axi_arvalid,
    vluint8_t  * axi_arready,
    vluint8_t  * axi_arprot,
    vluint32_t * axi_araddr,
    read_req_queue_t * q
){
    if(!*axi_arvalid && !*axi_arready) {
        // Do nothing
    } else  if(!*axi_arvalid && *axi_arready) {
        // Do nothing
    } else  if(*axi_arvalid && !*axi_arready) {
        // Assert ready and add the request to the queue.
        *axi_arready = 1;
        q -> push(*axi_araddr);
    } else  if(*axi_arvalid && *axi_arready) {
        // Add the request to the queue.
        *axi_arready = 1;
        q -> push(*axi_araddr);
    }
}


/*
@brief Handle an AXI read channel response.
*/
void axi_read_channel_response(
    vluint8_t  * axi_rvalid,
    vluint8_t  * axi_rready,
    vluint32_t * axi_rdata,
    read_req_queue_t * q
){
    if(*axi_rvalid && !*axi_rready) {
        // Do nothing, wait for device to accept prior response.

    } else if(!q -> empty()) {
        // handle the next response.
        vluint32_t raddr = q -> front();
        
        vluint32_t rdata = mem_read_word(raddr);

        std::cout << "mem[" << raddr <<"] = " << rdata<<std::endl;

        *axi_rdata  = rdata;
        *axi_rvalid = 1;

        q -> pop();

    } else {
        // No responses left to handle. Clear rvalid.
        *axi_rvalid = 0;
    }
}

/*
@brief Called on every rising edge of the main clock.
*/
void posedge_gclk(top_module_t top) {
    std::cout << ".";

    // handle picorv axi read request channel
    axi_read_channel_request(
        &top -> prv_axi_arvalid,
        &top -> prv_axi_arready,
        &top -> prv_axi_arprot,
        &top -> prv_axi_araddr,
        &prv_read_requests
    );

    // handle coprocessor axi read request channel
    axi_read_channel_request(
        &top -> cop_axi_arvalid,
        &top -> cop_axi_arready,
        &top -> cop_axi_arprot,
        &top -> cop_axi_araddr,
        &cop_read_requests
    );

    // Handle picorv AXI read response channel
    axi_read_channel_response(
        &top -> prv_axi_rvalid,
        &top -> prv_axi_rready,
        &top -> prv_axi_rdata,
        &prv_read_requests
    );

    // Handle coprocessor AXI read response channel
    axi_read_channel_response(
        &top -> cop_axi_rvalid,
        &top -> cop_axi_rready,
        &top -> cop_axi_rdata,
        &cop_read_requests
    );
}

/*
@brief Top level simulation function.
@details Taken straight from the verilator examples.
*/
int main(int argc, char** argv, char** env) {
    
    Verilated::commandArgs(argc, argv);
    
    top_module_t top        = new Vscarv_prv_xcrypt_top;
    vluint64_t   main_time  = 0;       // Current simulation time

    // Put model in reset.
    top -> g_resetn = 0;
    top -> g_clk    = 0;
    
    top -> cop_axi_arready  = 0;
    top -> cop_axi_awready  = 0;
    top -> cop_axi_bvalid   = 0;
    top -> cop_axi_rdata    = 0;
    top -> cop_axi_rvalid   = 0;
    top -> cop_axi_wready   = 0;
    top -> prv_axi_arready  = 0;
    top -> prv_axi_awready  = 0;
    top -> prv_axi_bvalid   = 0;
    top -> prv_axi_rdata    = 0;
    top -> prv_axi_rvalid   = 0;
    top -> prv_axi_wready   = 0;
    top -> prv_irq          = 0;

    while (!Verilated::gotFinish() && (main_time < max_time)) {
        
        top->eval();

        if(main_time > 80) {
            top -> g_resetn = 1;
        }

        // make the clock go.
        if((main_time % 10) == 1) {

            top -> g_clk = 1;
            
            posedge_gclk(top);

        } else if((main_time % 10) == 6) {
            
            top -> g_clk = 0;

        }

        main_time ++;

    }

    std::cout << "FINISH" << std::endl;

    delete top;
    exit(0);
}
