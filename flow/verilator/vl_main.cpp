
#include <assert.h>

#include <map>
#include <queue>
#include <string>
#include <iostream>

#include "srec.hpp"

#include "Vscarv_prv_xcrypt_top.h"
#include "verilated.h"

const vluint32_t TB_PASS_ADDRESS  = 0x00000001C;
const vluint32_t TB_FAIL_ADDRESS  = 0x000000010;

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
    bool       complete; // Do we have write address *and* data info?
} write_request_t;

//! Typedef for write request queues.
typedef std::queue<write_request_t*> write_req_queue_t;

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

        //std::cout << "mem[" << raddr <<"] = " << std::hex<<rdata<<std::endl;

        *axi_rdata  = rdata;
        *axi_rvalid = 1;

        q -> pop();

    } else {
        // No responses left to handle. Clear rvalid.
        *axi_rvalid = 0;
    }
}


/*
@brief Capture any new write address channel requests
@details Address channel requests are added to the back of the
    ``q``. If there is already a captured request object at the back
    of the queue with no data information (i.e. the complete field is false)
    then this function clears axi_awready and exits immediately.
*/
void axi_write_addr_channel_request(
    vluint8_t   * axi_awvalid,
    vluint8_t   * axi_awready,
    vluint8_t   * axi_awprot,
    vluint32_t  * axi_awaddr,
    write_req_queue_t * q
){

    if(q -> empty() == false) {
        if(q -> back() -> complete == false) {
            // Don't accept any new requests until current
            // one has both data and address information.
            *axi_awready = 0;
            return;
        }
    }

    if(!*axi_awvalid && !*axi_awready) {
        // Do nothing
    } else  if(!*axi_awvalid && *axi_awready) {
        // Do nothing
    } else  if(*axi_awvalid) {
        // Assert ready and add the request to the queue.
        *axi_awready = 1;
        
        write_request_t * nr = new write_request_t;
        nr -> complete  = false;
        nr -> waddr     = *axi_awaddr;

        q -> push(nr);
    }
}


/*
@brief Fill out the remaining AXI write request information left
    in structure created by axi_write_addr_channel_request
*/
void axi_write_data_channel_request (
    vluint8_t   * axi_wvalid,
    vluint8_t   * axi_wready,
    vluint8_t   * axi_wstrb,
    vluint32_t  * axi_wdata,
    write_req_queue_t * q
){
    if(!*axi_wvalid && !*axi_wready) {
        // Do nothing
    } else  if(!*axi_wvalid && *axi_wready) {
        // Do nothing
    } else  if(*axi_wvalid) {
        // Assert ready and add the request to the queue.
        *axi_wready = 1;
        
        assert(q -> empty() == false);
        assert(q -> back() -> complete == false);

        q -> back() -> wdata    = *axi_wdata;
        q -> back() -> wstrb    = *axi_wstrb;
        q -> back() -> complete = true;
    }
}


void axi_write_channel_response (
    vluint8_t   * axi_bvalid,
    vluint8_t   * axi_bready,
    write_req_queue_t * q
){

    if(*axi_bvalid && !*axi_bready) {
        
        // Don't pop anything, still waiting for previous write response to
        // be accepted.

    } else if((*axi_bvalid && *axi_bready) || !*axi_bvalid) {

        // Signal another response
        if(q -> empty()){
            *axi_bvalid = 0;
        } else if(q -> front() -> complete == false) {
            *axi_bvalid = 0;
        } else {
            *axi_bvalid = 1;
            write_request_t * f = q -> front();
            q -> pop();
            delete f;
        }

    }
}


/*
@brief Called on every rising edge of the main clock.
*/
void posedge_gclk(top_module_t top) {

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

    // Handle picorv axi write address channel
    axi_write_addr_channel_request(
        &top -> prv_axi_awvalid,
        &top -> prv_axi_awready,
        &top -> prv_axi_awprot,
        &top -> prv_axi_awaddr,
        &prv_write_requests
    );
    
    // Handle coprocessor axi write address channel
    axi_write_addr_channel_request(
        &top -> cop_axi_awvalid,
        &top -> cop_axi_awready,
        &top -> cop_axi_awprot,
        &top -> cop_axi_awaddr,
        &cop_write_requests
    );

    // Handle picorv axi write data channel
    axi_write_data_channel_request(
        &top -> prv_axi_wvalid,
        &top -> prv_axi_wready,
        &top -> prv_axi_wstrb,
        &top -> prv_axi_wdata,
        &prv_write_requests
    );

    // Handle coprocessor axi write data channel
    axi_write_data_channel_request(
        &top -> cop_axi_wvalid,
        &top -> cop_axi_wready,
        &top -> cop_axi_wstrb,
        &top -> cop_axi_wdata,
        &cop_write_requests
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

    // Handle picorv32 write channel response
    axi_write_channel_response(
        &top -> prv_axi_bvalid,
        &top -> prv_axi_bready,
        &prv_write_requests
    );

    // Handle coprocessor write channel response
    axi_write_channel_response(
        &top -> cop_axi_bvalid,
        &top -> cop_axi_bready,
        &cop_write_requests
    );
}


/*!
@brief loads hex files into memory.
*/
void load_main_memory(std::string fpath) {
    std::cout << "Loading memory image: " << fpath << std::endl;

    srec::srec_file fc (fpath);

    for(auto p : fc.data) {
        vluint32_t addr = p.first & 0xFFFFFFFF;
        vluint8_t  data = p.second;

        main_memory[addr] = data;
    }
}

/*
@brief Responsible for parsing all of the command line arguments.
*/
void process_arguments(int argc, char ** argv) {

    for(int i =0; i < argc; i ++) {
        std::string s (argv[i]);

        if(s.find("+IMEM=") != std::string::npos) {
            // Extract the file path.
            std::string fpath = s.substr(6);
            load_main_memory(fpath);
        }
    }
}


/*!
@brief Check if pass/fail conditions for the simulation are met.
@return true iff the simulation should finish, false otherwise.
*/
bool check_pass_fail(
    vluint8_t  * axi_arvalid,
    vluint32_t * axi_araddr
){
    if(*axi_arvalid) {
        if(*axi_araddr == TB_PASS_ADDRESS) {
            std::cout <<"SIM PASS" << std::endl;
            return true;
        } else if(*axi_araddr == TB_FAIL_ADDRESS) {
            std::cout <<"SIM FAIL" << std::endl;
            return true;
        }
    }
    return false;
}

/*
@brief Top level simulation function.
@details Taken straight from the verilator examples.
*/
int main(int argc, char** argv, char** env) {
    
    Verilated::commandArgs(argc, argv);

    process_arguments(argc,argv);
    
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

        bool stop = check_pass_fail(
            &top -> prv_axi_arvalid,
            &top -> prv_axi_araddr
        );
    
        if(stop) {break;}
    }

    std::cout << "FINISH" << std::endl;

    delete top;
    exit(0);
}
