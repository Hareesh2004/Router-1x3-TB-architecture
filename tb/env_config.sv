class env_config extends uvm_object;


`uvm_object_utils(env_config)

bit has_wagent = 1;
bit has_ragent = 1;
// Whether the virtual sequencer is used:
bit has_virtual_sequencer = 1;
bit has_scoreboard= 1;
wr_agent_config m_wr_agent_cfg;

rd_agent_config m_rd_agent_cfg[];

int no_of_read_agents=3;
int no_of_write_agents= 1;

extern function new(string name = "env_config");

endclass: env_config

function env_config::new(string name = "env_config");
  super.new(name);
endfunction


