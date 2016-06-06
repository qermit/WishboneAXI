library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WishboneAXI_v0_1_M_AXI4_LITE is
  generic (
    -- Users to add parameters here
    C_WB_ADR_WIDTH : integer;
    C_WB_DAT_WIDTH : integer;
    C_WB_MODE      : string;
    -- User parameters ends
    -- Do not modify the parameters beyond this line

    -- The master will start generating data from the C_M_START_DATA_VALUE value
    C_M_START_DATA_VALUE       : std_logic_vector := x"AA000000";
    -- The master requires a target slave base address.
    -- The master will initiate read and write transactions on the slave with base address specified here as a parameter.
    C_M_TARGET_SLAVE_BASE_ADDR : std_logic_vector := x"40000000";
    -- Width of M_AXI address bus. 
    -- The master generates the read and write addresses of width specified as C_M_AXI_ADDR_WIDTH.
    C_M_AXI_ADDR_WIDTH         : integer          := 32;
    -- Width of M_AXI data bus. 
    -- The master issues write data and accept read data where the width of the data bus is C_M_AXI_DATA_WIDTH
    C_M_AXI_DATA_WIDTH         : integer          := 32;
    -- Transaction number is the number of write 
    -- and read transactions the master will perform as a part of this example memory test.
    C_M_TRANSACTIONS_NUM       : integer          := 4
    );
  port (
    -- Users to add ports here
    s_wb_aclk    : in  std_logic;
    s_wb_aresetn : in  std_logic;
    s_wb_adr     : in  std_logic_vector(C_WB_ADR_WIDTH-1 downto 0);
    s_wb_dat_w   : in  std_logic_vector(C_WB_DAT_WIDTH-1 downto 0);
    s_wb_cyc     : in  std_logic;
    s_wb_stb     : in  std_logic;
    s_wb_lock    : in  std_logic;
    s_wb_sel     : in  std_logic_vector(C_WB_DAT_WIDTH/8-1 downto 0);
    s_wb_we      : in  std_logic;
    s_wb_dat_r   : out std_logic_vector(C_WB_DAT_WIDTH-1 downto 0);
    s_wb_stall   : out std_logic;
    s_wb_err     : out std_logic;
    s_wb_rty     : out std_logic;
    s_wb_ack     : out std_logic;
    -- User ports ends
    -- Do not modify the ports beyond this line

    -- Initiate AXI transactions
    INIT_AXI_TXN  : in  std_logic;
    -- Asserts when ERROR is detected
    error         : out std_logic;
    -- Asserts when AXI transactions is complete
    TXN_DONE      : out std_logic;
    -- AXI clock signal
    M_AXI_ACLK    : in  std_logic;
    -- AXI active low reset signal
    M_AXI_ARESETN : in  std_logic;
    -- Master Interface Write Address Channel ports. Write address (issued by master)
    M_AXI_AWADDR  : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    -- Write channel Protection type.
    -- This signal indicates the privilege and security level of the transaction,
    -- and whether the transaction is a data access or an instruction access.
    M_AXI_AWPROT  : out std_logic_vector(2 downto 0);
    -- Write address valid. 
    -- This signal indicates that the master signaling valid write address and control information.
    M_AXI_AWVALID : out std_logic;
    -- Write address ready. 
    -- This signal indicates that the slave is ready to accept an address and associated control signals.
    M_AXI_AWREADY : in  std_logic;
    -- Master Interface Write Data Channel ports. Write data (issued by master)
    M_AXI_WDATA   : out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    -- Write strobes. 
    -- This signal indicates which byte lanes hold valid data.
    -- There is one write strobe bit for each eight bits of the write data bus.
    M_AXI_WSTRB   : out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
    -- Write valid. This signal indicates that valid write data and strobes are available.
    M_AXI_WVALID  : out std_logic;
    -- Write ready. This signal indicates that the slave can accept the write data.
    M_AXI_WREADY  : in  std_logic;
    -- Master Interface Write Response Channel ports. 
    -- This signal indicates the status of the write transaction.
    M_AXI_BRESP   : in  std_logic_vector(1 downto 0);
    -- Write response valid. 
    -- This signal indicates that the channel is signaling a valid write response
    M_AXI_BVALID  : in  std_logic;
    -- Response ready. This signal indicates that the master can accept a write response.
    M_AXI_BREADY  : out std_logic;
    -- Master Interface Read Address Channel ports. Read address (issued by master)
    M_AXI_ARADDR  : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    -- Protection type. 
    -- This signal indicates the privilege and security level of the transaction, 
    -- and whether the transaction is a data access or an instruction access.
    M_AXI_ARPROT  : out std_logic_vector(2 downto 0);
    -- Read address valid. 
    -- This signal indicates that the channel is signaling valid read address and control information.
    M_AXI_ARVALID : out std_logic;
    -- Read address ready. 
    -- This signal indicates that the slave is ready to accept an address and associated control signals.
    M_AXI_ARREADY : in  std_logic;
    -- Master Interface Read Data Channel ports. Read data (issued by slave)
    M_AXI_RDATA   : in  std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    -- Read response. This signal indicates the status of the read transfer.
    M_AXI_RRESP   : in  std_logic_vector(1 downto 0);
    -- Read valid. This signal indicates that the channel is signaling the required read data.
    M_AXI_RVALID  : in  std_logic;
    -- Read ready. This signal indicates that the master can accept the read data and response information.
    M_AXI_RREADY  : out std_logic
    );
end WishboneAXI_v0_1_M_AXI4_LITE;

architecture implementation of WishboneAXI_v0_1_M_AXI4_LITE is

  -- function called clogb2 that returns an integer which has the
  -- value of the ceiling of the log base 2
  function clogb2 (bit_depth : integer) return integer is
    variable depth : integer := bit_depth;
    variable count : integer := 1;
  begin
    for clogb2 in 1 to bit_depth loop   -- Works for up to 32 bit integers
      if (bit_depth <= 2) then
        count := 1;
      else
        if(depth <= 1) then
          count := count;
        else
          depth := depth / 2;
          count := count + 1;
        end if;
      end if;
    end loop;
    return(count);
  end;

  -- Example user application signals

  -- TRANS_NUM_BITS is the width of the index counter for
  -- number of write or read transaction..
  constant TRANS_NUM_BITS : integer := clogb2(C_M_TRANSACTIONS_NUM-1);

  -- Example State machine to initialize counter, initialize write transactions, 
  -- initialize read transactions and comparison of read data with the 
  -- written data words.
  type state is (IDLE,            -- This state initiates AXI4Lite transaction
                                  -- after the state machine changes state to INIT_WRITE
                                  -- when there is 0 to 1 transition on INIT_AXI_TXN
                  INIT_WRITE,     -- This state initializes write transaction,
                                  -- once writes are done, the state machine 
                                  -- changes state to INIT_READ 
                  INIT_READ,      -- This state initializes read transaction
                                  -- once reads are done, the state machine 
                                  -- changes state to INIT_COMPARE 
                  INIT_COMPARE);  -- This state issues the status of comparison 
                                  -- of the written data with the read data

  signal mst_exec_state : state;

  -- AXI4LITE signals
  --write address valid
  signal axi_awvalid        : std_logic;
  --write data valid
  signal axi_wvalid         : std_logic;
  --read address valid
  signal axi_arvalid        : std_logic;
  --read data acceptance
  signal axi_rready         : std_logic;
  --write response acceptance
  signal axi_bready         : std_logic;
  --write address
  signal axi_awaddr         : std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
  --write data
  signal axi_wdata          : std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
  --read addresss
  signal axi_araddr         : std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
  --Asserts when there is a write response error
  signal write_resp_error   : std_logic;
  --Asserts when there is a read response error
  signal read_resp_error    : std_logic;
  --A pulse to initiate a write transaction
  signal start_single_write : std_logic;
  --A pulse to initiate a read transaction
  signal start_single_read  : std_logic;
  --Asserts when a single beat write transaction is issued and remains asserted till the completion of write trasaction.
  signal write_issued       : std_logic;
  --Asserts when a single beat read transaction is issued and remains asserted till the completion of read trasaction.
  signal read_issued        : std_logic;
  --flag that marks the completion of write trasactions. The number of write transaction is user selected by the parameter C_M_TRANSACTIONS_NUM.
  signal writes_done        : std_logic;
  --flag that marks the completion of read trasactions. The number of read transaction is user selected by the parameter C_M_TRANSACTIONS_NUM
  signal reads_done         : std_logic;
  --The error register is asserted when any of the write response error, read response error or the data mismatch flags are asserted.
  signal error_reg          : std_logic;
  --index counter to track the number of write transaction issued
  signal write_index        : std_logic_vector(TRANS_NUM_BITS downto 0);
  --index counter to track the number of read transaction issued
  signal read_index         : std_logic_vector(TRANS_NUM_BITS downto 0);
  --Expected read data used to compare with the read data.
  signal expected_rdata     : std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
  --Flag marks the completion of comparison of the read data with the expected read data
  signal compare_done       : std_logic;
  --This flag is asserted when there is a mismatch of the read data with the expected read data.
  signal read_mismatch      : std_logic;
  --Flag is asserted when the write index reaches the last write transction number
  signal last_write         : std_logic;
  --Flag is asserted when the read index reaches the last read transction number
  signal last_read          : std_logic;
  signal init_txn_ff        : std_logic;
  signal init_txn_ff2       : std_logic;
  signal init_txn_edge      : std_logic;
  signal init_txn_pulse     : std_logic;


begin
  -- I/O Connections assignments

  --Adding the offset address to the base addr of the slave
  M_AXI_AWADDR   <= std_logic_vector (unsigned(C_M_TARGET_SLAVE_BASE_ADDR) + unsigned(axi_awaddr));
  --AXI 4 write data
  M_AXI_WDATA    <= axi_wdata;
  M_AXI_AWPROT   <= "000";
  M_AXI_AWVALID  <= axi_awvalid;
  --Write Data(W)
  M_AXI_WVALID   <= axi_wvalid;
  --Set all byte strobes in this example
  M_AXI_WSTRB    <= "1111";
  --Write Response (B)
  M_AXI_BREADY   <= axi_bready;
  --Read Address (AR)
  M_AXI_ARADDR   <= std_logic_vector(unsigned(C_M_TARGET_SLAVE_BASE_ADDR) + unsigned(axi_araddr));
  M_AXI_ARVALID  <= axi_arvalid;
  M_AXI_ARPROT   <= "001";
  --Read and Read Response (R)
  M_AXI_RREADY   <= axi_rready;
  --Example design I/O
  TXN_DONE       <= compare_done;
  init_txn_pulse <= (not init_txn_ff2) and init_txn_ff;


  --Generate a pulse to initiate AXI transaction.
  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      -- Initiates AXI transaction delay        
      if (M_AXI_ARESETN = '0') then
        init_txn_ff  <= '0';
        init_txn_ff2 <= '0';
      else
        init_txn_ff  <= INIT_AXI_TXN;
        init_txn_ff2 <= init_txn_ff;
      end if;
    end if;
  end process;


  ----------------------
  --Write Address Channel
  ----------------------

  -- The purpose of the write address channel is to request the address and 
  -- command information for the entire transaction.  It is a single beat
  -- of information.

  -- Note for this example the axi_awvalid/axi_wvalid are asserted at the same
  -- time, and then each is deasserted independent from each other.
  -- This is a lower-performance, but simplier control scheme.

  -- AXI VALID signals must be held active until accepted by the partner.

  -- A data transfer is accepted by the slave when a master has
  -- VALID data and the slave acknoledges it is also READY. While the master
  -- is allowed to generated multiple, back-to-back requests by not 
  -- deasserting VALID, this design will add rest cycle for
  -- simplicity.

  -- Since only one outstanding transaction is issued by the user design,
  -- there will not be a collision between a new request and an accepted
  -- request on the same clock cycle. 

  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      --Only VALID signals must be deasserted during reset per AXI spec             
      --Consider inverting then registering active-low reset for higher fmax        
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        axi_awvalid <= '0';
      else
        --Signal a new address/data command is available by user logic              
        if (start_single_write = '1') then
          axi_awvalid <= '1';
        elsif (M_AXI_AWREADY = '1' and axi_awvalid = '1') then
          --Address accepted by interconnect/slave (issue of M_AXI_AWREADY by slave)
          axi_awvalid <= '0';
        end if;
      end if;
    end if;
  end process;

  -- start_single_write triggers a new write                                        
  -- transaction. write_index is a counter to                                       
  -- keep track with number of write transaction                                    
  -- issued/initiated                                                               
  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        write_index <= (others => '0');
      elsif (start_single_write = '1') then
        -- Signals a new write address/ write data is                               
        -- available by user logic                                                  
        write_index <= std_logic_vector (unsigned(write_index) + 1);
      end if;
    end if;
  end process;


  ----------------------
  --Write Data Channel
  ----------------------

  --The write data channel is for transfering the actual data.
  --The data generation is speific to the example design, and 
  --so only the WVALID/WREADY handshake is shown here

  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        axi_wvalid <= '0';
      else
        if (start_single_write = '1') then
          --Signal a new address/data command is available by user logic        
          axi_wvalid <= '1';
        elsif (M_AXI_WREADY = '1' and axi_wvalid = '1') then
          --Data accepted by interconnect/slave (issue of M_AXI_WREADY by slave)
          axi_wvalid <= '0';
        end if;
      end if;
    end if;
  end process;


  ------------------------------
  --Write Response (B) Channel
  ------------------------------

  --The write response channel provides feedback that the write has committed
  --to memory. BREADY will occur after both the data and the write address
  --has arrived and been accepted by the slave, and can guarantee that no
  --other accesses launched afterwards will be able to be reordered before it.

  --The BRESP bit [1] is used indicate any errors from the interconnect or
  --slave for the entire write burst. This example will capture the error.

  --While not necessary per spec, it is advisable to reset READY signals in
  --case of differing reset latencies between master/slave.

  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        axi_bready <= '0';
      else
        if (M_AXI_BVALID = '1' and axi_bready = '0') then
          -- accept/acknowledge bresp with axi_bready by the master    
          -- when M_AXI_BVALID is asserted by slave                    
          axi_bready <= '1';
        elsif (axi_bready = '1') then
          -- deassert after one clock cycle                            
          axi_bready <= '0';
        end if;
      end if;
    end if;
  end process;
  --Flag write errors                                                    
  write_resp_error <= (axi_bready and M_AXI_BVALID and M_AXI_BRESP(1));


  ------------------------------
  --Read Address Channel
  ------------------------------

  --start_single_read triggers a new read transaction. read_index is a counter to
  --keep track with number of read transaction issued/initiated

  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        read_index <= (others => '0');
      else
        if (start_single_read = '1') then
          -- Signals a new read address is                                         
          -- available by user logic                                               
          read_index <= std_logic_vector (unsigned(read_index) + 1);
        end if;
      end if;
    end if;
  end process;

  -- A new axi_arvalid is asserted when there is a valid read address              
  -- available by the master. start_single_read triggers a new read                
  -- transaction                                                                   
  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        axi_arvalid <= '0';
      else
        if (start_single_read = '1') then
          --Signal a new read address command is available by user logic           
          axi_arvalid <= '1';
        elsif (M_AXI_ARREADY = '1' and axi_arvalid = '1') then
          --RAddress accepted by interconnect/slave (issue of M_AXI_ARREADY by slave)
          axi_arvalid <= '0';
        end if;
      end if;
    end if;
  end process;


  ----------------------------------
  --Read Data (and Response) Channel
  ----------------------------------

  --The Read Data channel returns the results of the read request 
  --The master will accept the read data by asserting axi_rready
  --when there is a valid read data available.
  --While not necessary per spec, it is advisable to reset READY signals in
  --case of differing reset latencies between master/slave.

  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        axi_rready <= '1';
      else
        if (M_AXI_RVALID = '1' and axi_rready = '0') then
          -- accept/acknowledge rdata/rresp with axi_rready by the master
          -- when M_AXI_RVALID is asserted by slave                      
          axi_rready <= '1';
        elsif (axi_rready = '1') then
          -- deassert after one clock cycle                             
          axi_rready <= '0';
        end if;
      end if;
    end if;
  end process;

  --Flag write errors                                                     
  read_resp_error <= (axi_rready and M_AXI_RVALID and M_AXI_RRESP(1));


  ----------------------------------
  --User Logic
  ----------------------------------

  --Address/Data Stimulus

  --Address/data pairs for this example. The read and write values should
  --match.
  --Modify these as desired for different address patterns.

  --  Write Addresses                                                               
  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        axi_awaddr <= (others => '0');
      elsif (M_AXI_AWREADY = '1' and axi_awvalid = '1') then
        -- Signals a new write address/ write data is                               
        -- available by user logic                                                  
        axi_awaddr <= std_logic_vector (unsigned(axi_awaddr) + 4);
      end if;
    end if;
  end process;

  -- Read Addresses                                                                      
  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        axi_araddr <= (others => '0');
      elsif (M_AXI_ARREADY = '1' and axi_arvalid = '1') then
        -- Signals a new write address/ write data is                           
        -- available by user logic                                              
        axi_araddr <= std_logic_vector (unsigned(axi_araddr) + 4);
      end if;
    end if;
  end process;

  -- Write data                                                                          
  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        axi_wdata <= C_M_START_DATA_VALUE;
      elsif (M_AXI_WREADY = '1' and axi_wvalid = '1') then
        -- Signals a new write address/ write data is                               
        -- available by user logic                                                  
        axi_wdata <= std_logic_vector (unsigned(C_M_START_DATA_VALUE) + unsigned(write_index));
      end if;
    end if;
  end process;


  -- Expected read data                                                                  
  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        expected_rdata <= C_M_START_DATA_VALUE;
      elsif (M_AXI_RVALID = '1' and axi_rready = '1') then
        -- Signals a new write address/ write data is                                
        -- available by user logic                                                   
        expected_rdata <= std_logic_vector (unsigned(C_M_START_DATA_VALUE) + unsigned(read_index));
      end if;
    end if;
  end process;
  --implement master command interface state machine                                           
  MASTER_EXECUTION_PROC : process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0') then
        -- reset condition                                                                          
        -- All the signals are ed default values under reset condition                              
        mst_exec_state     <= IDLE;
        start_single_write <= '0';
        write_issued       <= '0';
        start_single_read  <= '0';
        read_issued        <= '0';
        compare_done       <= '0';
        error              <= '0';
      else
        -- state transition                                                                         
        case (mst_exec_state) is
          
          when IDLE =>
            -- This state is responsible to initiate
            -- AXI transaction when init_txn_pulse is asserted 
            if (init_txn_pulse = '1') then
              mst_exec_state <= INIT_WRITE;
              error          <= '0';
              compare_done   <= '0';
            else
              mst_exec_state <= IDLE;
            end if;
            
          when INIT_WRITE =>
            -- This state is responsible to issue start_single_write pulse to                       
            -- initiate a write transaction. Write transactions will be                             
            -- issued until last_write signal is asserted.                                          
            -- write controller                                                                     
            if (writes_done = '1') then
              mst_exec_state <= INIT_READ;
            else
              mst_exec_state <= INIT_WRITE;
              
              if (axi_awvalid = '0' and axi_wvalid = '0' and M_AXI_BVALID = '0' and
                  last_write = '0' and start_single_write = '0' and write_issued = '0') then          
                start_single_write <= '1';
                write_issued       <= '1';
              elsif (axi_bready = '1') then
                write_issued <= '0';
              else
                start_single_write <= '0';  --Negate to generate a pulse                             
              end if;
            end if;
            
          when INIT_READ =>
            -- This state is responsible to issue start_single_read pulse to                        
            -- initiate a read transaction. Read transactions will be                               
            -- issued until last_read signal is asserted.                                           
            -- read controller                                                                      
            if (reads_done = '1') then
              mst_exec_state <= INIT_COMPARE;
            else
              mst_exec_state <= INIT_READ;
              
              if (axi_arvalid = '0' and M_AXI_RVALID = '0' and last_read = '0' and
                  start_single_read = '0' and read_issued = '0') then                                 
                start_single_read <= '1';
                read_issued       <= '1';
              elsif (axi_rready = '1') then
                read_issued <= '0';
              else
                start_single_read <= '0';  --Negate to generate a pulse                              
              end if;
            end if;
            
          when INIT_COMPARE =>
            -- This state is responsible to issue the state of comparison                           
            -- of written data with the read data. If no error flags are set,                       
            -- compare_done signal will be asseted to indicate success.                             
            error          <= error_reg;
            mst_exec_state <= IDLE;
            compare_done   <= '1';
            
          when others =>
            mst_exec_state <= IDLE;
        end case;
      end if;
    end if;
  end process;

  --Terminal write count                                                                              
  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        -- reset condition                                                                          
        last_write <= '0';
      else
        --The last write should be associated with a write address ready response                   
        if (write_index = std_logic_vector(TO_UNSIGNED(C_M_TRANSACTIONS_NUM, TRANS_NUM_BITS+1)) and M_AXI_AWREADY = '1') then
          last_write <= '1';
        end if;
      end if;
    end if;
  end process;

  --/*                                                                                                
  -- Check for last write completion.                                                                 
  --                                                                                                  
  -- This logic is to qualify the last write count with the final write                               
  -- response. This demonstrates how to confirm that a write has been                                 
  -- committed.                                                                                       
  -- */                                                                                               
  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        -- reset condition                                                                          
        writes_done <= '0';
      else
        if (last_write = '1' and M_AXI_BVALID = '1' and axi_bready = '1') then
          --The writes_done should be associated with a bready response                             
          writes_done <= '1';
        end if;
      end if;
    end if;
  end process;

  --------------                                                                                      
  --Read example                                                                                      
  --------------                                                                                      

  --Terminal Read Count                                                                               

  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        last_read <= '0';
      else
        if (read_index = std_logic_vector(TO_UNSIGNED(C_M_TRANSACTIONS_NUM, TRANS_NUM_BITS+1)) and (M_AXI_ARREADY = '1')) then
          --The last read should be associated with a read address ready response                   
          last_read <= '1';
        end if;
      end if;
    end if;
  end process;


  --/*                                                                                                
  -- Check for last read completion.                                                                  
  --                                                                                                  
  -- This logic is to qualify the last read count with the final read                                 
  -- response/data.                                                                                   
  -- */                                                                                               
  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        reads_done <= '0';
      else
        if (last_read = '1' and M_AXI_RVALID = '1' and axi_rready = '1') then
          --The reads_done should be associated with a read ready response                          
          reads_done <= '1';
        end if;
      end if;
    end if;
  end process;


  ------------------------------/                                                                     
  --Example design error register                                                                     
  ------------------------------/                                                                     

  --Data Comparison                                                                                   
  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        read_mismatch <= '0';
      else
        if ((M_AXI_RVALID = '1' and axi_rready = '1') and M_AXI_RDATA /= expected_rdata) then
          --The read data when available (on axi_rready) is compared with the expected data         
          read_mismatch <= '1';
        end if;
      end if;
    end if;
  end process;

  -- Register and hold any data mismatches, or read/write interface errors                            
  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        error_reg <= '0';
      else
        if (read_mismatch = '1' or write_resp_error = '1' or read_resp_error = '1') then
          --Capture any error types                                                                 
          error_reg <= '1';
        end if;
      end if;
    end if;
  end process;

  -- Add user logic here

  -- User logic ends

end implementation;
