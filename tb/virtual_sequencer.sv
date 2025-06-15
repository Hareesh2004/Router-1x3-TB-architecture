class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item) ;

   // Factory Registration
        `uvm_component_utils(virtual_sequencer)

	wr_sequencer wr_seqrh;
        rd_sequencer rd_seqrh[];

       env_config m_cfg;

	extern function new(string name = "virtual_sequencer",uvm_component parent);
        extern function void build_phase(uvm_phase phase);

endclass

function virtual_sequencer::new(string name="virtual_sequencer",uvm_component parent);
                super.new(name,parent);
        endfunction

function void virtual_sequencer::build_phase(uvm_phase phase);
if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
        `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
if(m_cfg.has_virtual_sequencer)
begin
         if(m_cfg.has_ragent)
         rd_seqrh= new[m_cfg.no_of_read_agents];
 end
endfunction

