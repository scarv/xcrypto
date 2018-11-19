
#include <iostream>
#include <fstream>
#include <string>
#include <map>

#ifndef SREC_HPP
#define SREC_HPP

namespace srec {

/*!
@brief Represents a single SREC file contents as a key/value store.
*/
class srec_file {


    public:
        
        /*!
        @brief Open and parse the srec file specified in path
        @param in path - file path of the srec file to parse.
        */
        srec_file (
            std::string path
        );


        //! Mapping of SREC addresses onto SREC data.
        std::map<long unsigned, char unsigned> data;

        
        /*!
        @brief Dump out the parsed SREC data in a format suitable for
               parsing by Verilog/SystemVerilog's $readmemh function.
        @param word_size in - Number of bytes per memory word
        @param file_path in - File path to write too.
        @returns True if the file writing succeded. False otherwise.
        */
        bool dump_readmemh(
            unsigned char word_size,
            std::string   file_path
        );

    protected:


};

}


#endif
