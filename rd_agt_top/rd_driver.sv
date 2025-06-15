class rd_driver extends uvm_driver #(read_xtn);

  
        `uvm_component_utils(rd_driver)
    virtual router_if.RDR_MP vif;
     rd_agent_config m_cfg;

        extern function new(string name ="rd_driver",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task send_to_dut(read_xtn duv_xtn);
        extern function void report_phase(uvm_phase phase);
endclass

  function rd_driver::new (string name ="rd_driver", uvm_component parent);
           super.new(name, parent);
         endfunction : new

function void rd_driver::build_phase(uvm_phase phase);
        super.build_phase(phase);


          if(!uvm_config_db #(rd_agent_config)::get(this,"","rd_agent_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
        endfunction

  function void rd_driver::connect_phase(uvm_phase phase);

          vif = m_cfg.vif;
        endfunction

 task rd_driver::run_phase(uvm_phase phase);
                forever begin
                seq_item_port.get_next_item(req);
                send_to_dut(req);
                seq_item_port.item_done();
                end
        endtask

task rd_driver::send_to_dut (read_xtn duv_xtn);

fork: a1
begin
@(vif.r_dr_cb);
wait( vif.r_dr_cb.vld_out)
repeat(duv_xtn.no_of_clocks)
@(vif.r_dr_cb);
vif.r_dr_cb.read_enb <= 1'b1;

wait(! vif.r_dr_cb.vld_out)
vif.r_dr_cb.read_enb <= 1'b0;
end

begin
repeat(95)
@(vif.r_dr_cb);
end
join_any

duv_xtn.print();
disable a1;




endtask

 function void rd_driver::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: RAM read driver sent %0d transactions", m_cfg.drv_data_sent_cnt), UVM_LOW)
  endfunction

