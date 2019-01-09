
/*!
@brief A header for making it easier to output correct python code for the
benchmark automation suite.
*/

#ifndef XC_BENCHMARK_H
#define XC_BENCHMARK_H

#define XC_BENCHMARK_INIT \
    putstr("import sys\n"); \
    putstr("import os\n"); \
    putstr("sys.path.append(os.path.expandvars(\"$XC_HOME/flow/benchmarks\"))\n"); \
    putstr("from XCBenchmark import *\n"); \
    putstr("print('XCBenchmark begin')\n")

//! Create a new benchmark set with the supplied name, using the given
//! tester class.
#define XC_BENCHMARK_SET(NAME, TESTER) \
    putstr(#NAME); \
    putstr(" = ResultsSet('");\
    putstr(#NAME); \
    putstr("',testerClass = "); \
    putstr(#TESTER); \
    putstr("())\n");

// Add a record to the benchmark set
#define XC_BENCHMARK_SET_ADD(NAME, RECORD) \
    putstr(#NAME); \
    putstr(".addRecord("); \
    putstr(#RECORD); \
    putstr(")\n");

#define XC_BENCHMARK_RECORD(NAME) \
    putstr(#NAME); \
    putstr(" = ResultsSetRecord([],[],{},False)\n");

#define XC_BENCHMARK_RECORD_ADD_INPUT(RECORD, INPUT) \
    putstr(#RECORD); \
    putstr(".inputs.append("); \
    INPUT; \
    putstr(")\n");

#define XC_BENCHMARK_RECORD_ADD_OUTPUT(RECORD, OUTPUT) \
    putstr(#RECORD); \
    putstr(".outputs.append("); \
    OUTPUT; \
    putstr(")\n");

#define XC_BENCHMARK_RECORD_ADD_METRIC(RECORD, METRIC, VALUE) \
    putstr(#RECORD); \
    putstr(".metrics[\""); \
    putstr(#METRIC); \
    putstr("\"] = "); \
    VALUE; \
    putstr("\n");

#define XC_BENCHMARK_SET_REPORT(NAME) \
    putstr(#NAME); \
    putstr(".printResults()\n");

#define XC_BENCHMARK_SET_PASS(NAME) \
    putstr("print(\"%s - %s\" % (\""); \
    putstr(#NAME); \
    putstr("\","); \
    putstr(#NAME); \
    putstr(".allCorrect()))\n"); \
    putstr("if(not "); \
    putstr(#NAME); \
    putstr(".allCorrect()):\n"); \
    putstr("    sys.exit(1)\n");

#endif

