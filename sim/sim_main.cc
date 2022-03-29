/* ============================================================================
  A Verilog main() program that calls a local serial port co-simulator.
  =============================================================================*/
using namespace std;

#include <verilated.h>
#include "verilated_vcd_c.h"
#include "VTestHarness.h"       //auto created by the verilator from the rtl
#include "VTestHarness__Dpi.h"   //auto created by the verilator from the rtl that support dpi
#include "remote_bitbang.h"


int main(int argc,  char ** argv)
{
    printf("Built with %s %s.\n", Verilated::productName(),
    Verilated::productVersion());
    printf("Recommended: Verilator 4.0 or later.\n");


    // call commandArgs first!
    VerilatedContext* contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);

    // Set debug level, 0 is off, 9 is highest presently used
    Verilated::debug(0);
    // Randomization reset policy
    Verilated::randReset(2);
    Verilated::mkdir("./log");

    // Instantiate our design
    VTestHarness * ptTbTop = new VTestHarness;

    // Tracing (vcd)
    VerilatedVcdC * m_trace = NULL;
    const char* flag_vcd = Verilated::commandArgsPlusMatch("vcd");
    if (flag_vcd && 0==strcmp(flag_vcd, "+vcd"))
    {
        Verilated::traceEverOn(true); // Verilator must compute traced signals
        m_trace = new VerilatedVcdC;
        ptTbTop->trace(m_trace, 1); // Trace 99 levels of hierarchy
        m_trace->open("./log/tb.vcd");
    }

    FILE * trace_fd = NULL;
    // If verilator was invoked with --trace argument,
    // and if at run time passed the +trace argument, turn on tracing
    const char* flag_trace = Verilated::commandArgsPlusMatch("trace");
    if (flag_trace && 0==strcmp(flag_trace, "+trace"))
    {
        trace_fd = fopen("./log/tb.trace", "w");
    }

    int m_cpu_tickcount = 0;
    //int m_jtag_tickcount = 0;

    //jtag
    remote_bitbang_t * jtag = NULL;
    jtag = new remote_bitbang_t(9823);


    while(!contextp->gotFinish())  /* && m_cpu_tickcount < 200 */
    {
        //cpu reset
        if(m_cpu_tickcount<10)
        {
            ptTbTop->reset = 1;
        }
        else
        {
            if(ptTbTop->reset == 1)
                printf("reset the cpu,done \n");
            ptTbTop->reset = 0;
        }

        ptTbTop->clock = 0;


        ptTbTop->eval();
        if(m_trace)
        {
	        m_trace->dump(m_cpu_tickcount*10);   //  Tick every 10 ns
	    }

        ptTbTop->clock = 1;
        ptTbTop->eval();
        if(m_trace)
        {
            m_trace->dump(m_cpu_tickcount*10+5);   // Trailing edge dump
            m_trace->flush();
        }
        m_cpu_tickcount++;
    }

    if(m_trace)
    {
        m_trace->flush();
        m_trace->close();
    }

    if(trace_fd)
    {
        fflush(trace_fd);
        fclose(trace_fd);
    }

#if VM_COVERAGE
    VerilatedCov::write("log/coverage.dat");
#endif // VM_COVERAGE

    delete ptTbTop;
    delete jtag;
    exit(0);
}

