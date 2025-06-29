class rd_monitor extends uvm_monitor;

  // Factory Registration
	`uvm_component_utils(rd_monitor)

  // Declare virtual interface handle with RMON_MP as modport
   	virtual router_if.RMON_MP vif;

  // Declare the ram_wr_agent_config handle as "m_cfg"
        rd_agent_config m_cfg;

  // Analysis TLM port to connect the monitor to the scoreboard for lab09
  uvm_analysis_port #(read_xtn) monitor_port;
extern function new(string name = "rd_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
extern function void report_phase(uvm_phase phase);


endclass 

function rd_monitor::new (string name = "rd_monitor", uvm_component parent);
    super.new(name, parent);
// create object for handle monitor_port using new
    monitor_port = new("monitor_port", this);
  endfunction : new

	function void rd_monitor::build_phase(uvm_phase phase);
	// call super.build_phase(phase);
          super.build_phase(phase);
         
	// get the config object using uvm_config_db 
          
          
	  if(!uvm_config_db #(rd_agent_config)::get(this,"","rd_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
        endfunction

	function void rd_monitor::connect_phase(uvm_phase phase);
          
          vif = m_cfg.vif;
        endfunction

   task rd_monitor::run_phase(uvm_phase phase);
        forever
     
        // Call collect data task
       collect_data(); 
 
  
       endtask


  //Collect Reference Data from DUV IF 
task rd_monitor::collect_data();
read_xtn xtn;
xtn = read_xtn :: type_id :: create("xtn"); 

wait( vif.read_monitor_cb.read_enb)
@(vif.read_monitor_cb);
xtn.header = vif.read_monitor_cb.data_out;

xtn.payload = new[xtn.header[7:2]];

@(vif.read_monitor_cb);
foreach(xtn.payload[i])
begin

xtn.payload[i] = vif.read_monitor_cb.data_out;
@(vif.read_monitor_cb);
end

xtn.parity = vif.read_monitor_cb.data_out;

@(vif.read_monitor_cb);

monitor_port.write(xtn);

`uvm_info("FROM READ MON",$sformatf("printing from sequence \n %s", xtn.sprint()),UVM_LOW) 


endtask 


function void rd_monitor::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: RAM Read Monitor Collected %0d Transactions", m_cfg.mon_rcvd_xtn_cnt), UVM_LOW)
  endfunction         
     
  


