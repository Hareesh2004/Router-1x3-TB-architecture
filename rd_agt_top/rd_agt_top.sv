class rd_agt_top extends uvm_env;
     `uvm_component_utils(rd_agt_top)
      rd_agent agnth[];
        env_config m_cfg;
       extern function new(string name = "rd_agt_top" , uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
  endclass

function rd_agt_top::new(string name = "rd_agt_top" , uvm_component parent);
                super.new(name,parent);
        endfunction

 function void rd_agt_top::build_phase(uvm_phase phase);
                super.build_phase(phase);
              if(! uvm_config_db #(env_config)::get(this," ","env_config",m_cfg))
                        `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
        agnth=new[m_cfg.no_of_read_agents];


        foreach(m_cfg.m_rd_agent_cfg[i]) begin
                agnth[i]= rd_agent::type_id::create($sformatf("agnth[%0d]",i),this);
$display("READ AGENT ADDR IS **********************************************%0d",agnth[i]);

                uvm_config_db #(rd_agent_config) :: set(this, $sformatf("agnth[%0d]*",i),"rd_agent_config",m_cfg.m_rd_agent_cfg[i]);
                   end

        endfunction

task rd_agt_top::run_phase(uvm_phase phase);
                uvm_top.print_topology;
        endtask
                  
