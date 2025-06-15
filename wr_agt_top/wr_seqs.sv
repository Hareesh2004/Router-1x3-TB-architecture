class wbase_seq extends uvm_sequence #(write_xtn);  
	
  // Factory registration using `uvm_object_utils

	`uvm_object_utils(wbase_seq)  
  extern function new(string name ="wbase_seq");
	endclass
	function wbase_seq::new(string name ="wbase_seq");
		super.new(name);
	endfunction

class sequence1 extends wbase_seq;

  	
  // Factory registration using `uvm_object_utils
  	`uvm_object_utils(sequence1)

  extern function new(string name ="sequence1");
        extern task body();
	endclass
	function sequence1::new(string name = "sequence1");
		super.new(name);
	endfunction

	  
task sequence1::body();
     

           $display("-------------------------------------------------------SEQUENCE-------");
   	   req= write_xtn :: type_id :: create("req");
	// repeat(1)
	//begin	
	   start_item(req);
   	   assert(req.randomize() with {header[7:2] < 4'd14;} );
	   	   finish_item(req);
	          $display("-------------------------------------------------------SEQUENCE-------");

	 //end 
    	endtask
    	
    	class sequence2 extends wbase_seq;

`uvm_object_utils(sequence2)
bit[1:0]addr;
 extern function new(string name ="sequence2");
        extern task body();
        endclass

function sequence2::new(string name = "sequence2");
                super.new(name);
        endfunction

task sequence2::body();

req= write_xtn :: type_id :: create("req");

start_item(req);
           assert(req.randomize() with {header[7:2] inside {[50:55]} && header[1:0]==addr;});
        `uvm_info("router_WR_SEQUENCE",$sformatf("printing from soequence \n %s",req.sprint()),UVM_HIGH)

                   finish_item(req);
endtask

class sequence3 extends wbase_seq;

`uvm_object_utils(sequence3)
bit[1:0]addr;
 extern function new(string name ="sequence3");
        extern task body();
        endclass

function sequence3::new(string name = "sequence3");
                super.new(name);
        endfunction

task sequence3::body();

req= write_xtn :: type_id :: create("req");

start_item(req);
           assert(req.randomize() with {header[7:2] inside {[62:63]} && header[1:0]==addr;});
        `uvm_info("router_WR_SEQUENCE",$sformatf("printing from sequence \n %s",req.sprint()),UVM_HIGH)

                   finish_item(req);
endtask





