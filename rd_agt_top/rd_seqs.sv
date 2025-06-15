class rbase_seq extends uvm_sequence #(read_xtn);

 
        `uvm_object_utils(rbase_seq)
       extern function new(string name ="rbase_seq");
        endclass

function rbase_seq::new(string name ="rbase_seq");
                super.new(name);
        endfunction

 class rd_xtns_seq extends rbase_seq;

      extern function new(string name ="rd_xtns_seq");
        extern task body();
        endclass

        function rd_xtns_seq::new(string name = "rd_xtns_seq");
                super.new(name);
        endfunction

  task rd_xtns_seq ::body();

        super.body();
     req=read_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {no_of_clocks< 30;} );
        finish_item(req);

     
       endtask
                                                                                                                                                                    


