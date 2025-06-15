class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  uvm_tlm_analysis_fifo #(read_xtn) fifo_rdh[];
  uvm_tlm_analysis_fifo #(write_xtn) fifo_wrh;

  env_config m_cfg;

  write_xtn wr_data;
  read_xtn  rd_data;

  // Counters
  int unsigned wr_xtns_in = 0;
  int unsigned rd_xtns_in = 0;
  int unsigned xtns_dropped = 0;
  int unsigned xtns_compared = 0;

  // Functional Coverage Groups
  covergroup router_fcov1;
    option.per_instance = 1;

    CHANNEL : coverpoint write_cov_data.header[1:0] {
      bins low = {2'b00};
      bins mid1 = {2'b01};
       bins mid2 = {2'b10};
    }

    PAYLOAD_SIZE : coverpoint write_cov_data.header[7:2] {
      bins small_packet  = {[1:15]};
      bins medium_packet = {[16:30]};
      bins large_packet  = {[31:63]};
    }

    BAD_PKT : coverpoint write_cov_data.err {
      bins bad_pkt = {1};
    }

    CHANNEL_X_PAYLOAD_SIZE : cross CHANNEL, PAYLOAD_SIZE;
    CHANNEL_X_PAYLOAD_SIZE_X_BAD_PKT : cross CHANNEL, PAYLOAD_SIZE, BAD_PKT;
  endgroup

  covergroup router_fcov2;
    option.per_instance = 1;

 CHANNEL : coverpoint write_cov_data.header[1:0] {
      bins low = {2'b00};
      bins mid1 = {2'b01};
      bins mid2 = {2'b10};
    }

    PAYLOAD_SIZE : coverpoint write_cov_data.header[7:2] {
      bins small_packet  = {[1:15]};
      bins medium_packet = {[16:30]};
      bins large_packet  = {[31:63]};
    }

    CHANNEL_X_PAYLOAD_SIZE : cross CHANNEL, PAYLOAD_SIZE;
  endgroup

  // Temporary transaction handle for coverage sampling
  write_xtn write_cov_data;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);

    if (!uvm_config_db #(env_config)::get(this, "", "env_config", m_cfg))
      `uvm_fatal("CONFIG", "cannot get() m_cfg from uvm_config_db. Have you set() it?")

    fifo_rdh = new[m_cfg.no_of_read_agents];
    fifo_wrh = new("fifo_wrh", this);
    foreach (fifo_rdh[i])
      fifo_rdh[i] = new($sformatf("fifo_rdh[%0d]", i), this);

    router_fcov1 = new();
    router_fcov2 = new();
  endfunction

  // run_phase
  task run_phase(uvm_phase phase);
    forever begin
      fifo_wrh.get(wr_data);
         wr_data.print;
     wr_xtns_in++;

      case (wr_data.header[1:0])
        2'b00: begin fifo_rdh[0].get(rd_data); rd_xtns_in++; check_data(wr_data, rd_data);
        rd_data.print;
end
        2'b01: begin fifo_rdh[1].get(rd_data); rd_xtns_in++; check_data(wr_data, rd_data);
        rd_data.print;

end
        2'b10: begin fifo_rdh[2].get(rd_data); rd_xtns_in++; check_data(wr_data, rd_data);
        rd_data.print;
end
        default: begin
          `uvm_error("SCOREBOARD", "Invalid header. Transaction dropped.")
          xtns_dropped++;
        end
      endcase
    end
  endtask

  // check_data
  function void check_data(write_xtn wr_data, read_xtn rd_data);
    uvm_table_printer printer = new();
    printer.knobs.depth = 3;

    `uvm_info("SCOREBOARD", "------------------ WRITE TXN ------------------", UVM_LOW)
    `uvm_info("SCOREBOARD", wr_data.sprint(printer), UVM_LOW)

    `uvm_info("SCOREBOARD", "------------------ READ TXN -------------------", UVM_LOW)
    `uvm_info("SCOREBOARD", rd_data.sprint(printer), UVM_LOW)

    if (wr_data.header == rd_data.header)
      `uvm_info("SCOREBOARD", "HEADER MATCHED", UVM_LOW)
    else
`uvm_error("SCOREBOARD", "HEADER MISMATCH")

    if (wr_data.payload == rd_data.payload)
      `uvm_info("SCOREBOARD", "PAYLOAD MATCHED", UVM_LOW)
    else
      `uvm_error("SCOREBOARD", "PAYLOAD MISMATCH")

    if (wr_data.parity == rd_data.parity)
      `uvm_info("SCOREBOARD", "PARITY MATCHED", UVM_LOW)
    else
      `uvm_error("SCOREBOARD", "PARITY MISMATCH")

    // Sample functional coverage
   write_cov_data = wr_data;  // Assign for sampling
    router_fcov1.sample();
    router_fcov2.sample();

    xtns_compared++;
  endfunction

  // report_phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(),
 $sformatf("MSTB: ScoreBoard Summary\n Read Txns: %0d\n Write Txns: %0d\n Dropped: %0d\n Compared: %0d",
        rd_xtns_in, wr_xtns_in, xtns_dropped, xtns_compared),
      UVM_LOW)
  endfunction
endclass


